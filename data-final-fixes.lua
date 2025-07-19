-- Global configuration table
require("config")

-- Table of references to tables previously adjusted
local table_references = {} ---@type table


-- Utility function to determine if a table is an array
---@param table table The table to check
---@return boolean -- Whether the table is an array or not
local function is_array(table)
	-- Verify this is a table
	if type(table) ~= "table" then
		return false
	end

	local i = 0
	for _ in pairs(table) do
		i = i + 1
		if table[i] == nil then
			-- Table is not an array
			return false
		end
	end

	-- Table is an array
	return true
end


-- Utility function to determine if a table is a numerical dictionary
---@param table table The table to check
---@return boolean -- Whether the table is a numerical dictionary or not
local function is_numerical_dictionary(table)
	-- Verify this is a table
	if type(table) ~= "table" then
		return false
	end

	for _, v in pairs(table) do
		if type(v) ~= "number" then
			-- Table is not a numerical dictionary
			return false
		end
	end

	-- Table is a numerical dictionary
	return true
end


-- Utility function to determine if a string has a specific ending
---@param str string The string to check the ending of
---@param ending string	The string to check as the ending
---@return boolean -- Whether the string has the ending or not
local function string_ends_with(str, ending)
	-- Verify the parameters are strings
	if type(str) ~= "string" or type(ending) ~= "string" then
		return false
	end

	-- Determine if the given string has the given ending
	return string.sub(str, -#ending) == ending
end


---Clamps the given prototype property to the range set in config.lua
---@param type_name string the type name of the prototype being modified
---@param property_name string the name of the property being clamped
---@param base_value number the current value of the property
---@param min_value number? the minimum value to clamp to (inclusive)
---@param max_value number? the maximum value to clamp to (inclusive)
---@return number clamped the property value clamped to `min <= x <= max`
local function clamp_property(type_name, property_name, base_value, min_value, max_value)
	local full_path = type_name .. "." .. property_name
	if not min_value then
		min_value = prototype_values_clamp_low[full_path] or prototype_values_clamp_low[property_name] or math.huge * -1
	end
	if not max_value then
		max_value = prototype_values_clamp_high[full_path] or prototype_values_clamp_high[property_name] or math.huge
	end
	local ret = math.min(math.max(base_value, min_value), max_value)
	if ret ~= base_value then
		log(string.format("CLAMPED: %s.%s,  %s -> %s", type_name, property_name, base_value, ret))
	end
	return ret
end


-- Adjusts an energy value by the given multiplier
---@param value string The energy value to be adjusted
---@param multiplier number The multiplier for the energy value
---@return string -- The adjusted energy value
local function adjust_energy(value, multiplier)
	local start, stop = string.find(value, "^[0123456789.]+")

	-- If start or stop are not valid, something went wrong
	-- Log an error and return early
	if not (start and stop) then
		log("Error: Invalid value for adjust energy function")
		return value
	end

	--Trim the KW MW KJ MJ etc ending off energy values and append it after adjusting the numbers.
	local new_value = tonumber(string.sub(value, start, stop))
	new_value = new_value * multiplier
	return string.format("%s%s", new_value, string.sub(value, stop + 1, string.len(value)))
end


local function adjust_animation(animation)
	-- There are a few animations, notably the player movement speed animation that there is more
	-- than one reference to. If we have already adjusted that animation, we should not adjust it
	-- again. So the property "animation_speed" is set true.
	if not table_references[animation] or not table_references[animation]["animation_speed"] then
		table_references[animation] = table_references[animation] or {}
		table_references[animation]["animation_speed"] = true
		animation["animation_speed"] = (animation["animation_speed"] or 1) * gtts_time_scale
	end
end


-- Adjust the property values of the given object by the given multiplier
---@param object table The object to adjust the properties of
---@param type_name string The type of the object being adjusted
---@param path string The path to the object being adjusted
---@param property_list table The list of properties to adjust
---@param multiplier number The multiplier to adjust the properties by
---@return nil -- No return
local function apply_adjustments(object, type_name, path, property_list, multiplier)
	-- Iterate over all the properties in the given property list
	for _, property in ipairs(property_list) do
		-- Check that the object has the property, that it hasn't already been adjusted, and that it meets all the restrictions (if any)
		if object[property] and (not table_references[object] or not table_references[object][property]) then
			-- As a double check to avoid potential multiple references, tag each property that is changed so we don't change it again later
			table_references[object] = table_references[object] or {}
			table_references[object][property] = true

			-- A few properties are tables of values. In that case, just adjust all of them if they have not already been adjusted
			if type(object[property]) == "table" and not table_references[object[property]] and (is_array(object[property]) or is_numerical_dictionary(object[property])) then
				-- As a double check to avoid potential multiple references, record the table that is changed so we don't change it again later
				-- This is a case where we want to check if the table references are the same, not the contents
				table_references[object[property]] = true

				-- Iterate over all the entries in the table
				for k, v in pairs(object[property]) do
					object[property][k] = clamp_property(type_name, property, object[property][k] * multiplier)
					--log(string.format("Adjusted property \"%s.%s\" from %s to %s at path: %s", property, k, v, object[property][k], path))
				end

			-- If the property is a number, then simply multiply it by the multiplier
			elseif type(object[property]) == "number" then
				local initial = object[property]
				object[property] = clamp_property(type_name, property, object[property] * multiplier)

				if property == "acceleration" or property == "particle_vertical_acceleration" or property == "acceleration_rate" or property == "movement_acceleration" then
					object[property] = object[property] * gtts_time_scale
				end
				--log(string.format("Adjusted property \"%s\" from %s to %s at path: %s", property, initial, object[property], path))

			-- If the property is a string and the property list is one of the power rate lists, then use the adjust energy function to modify the property value
			elseif type(object[property]) == "string" and (string_ends_with(object[property], "W") or string_ends_with(object[property], "J")) then
				local initial = object[property]
				object[property] = adjust_energy(object[property], multiplier)
				--log(string.format("Adjusted property \"%s\" from %s to %s at path: %s", property, initial, object[property], path))
			end
		end
	end
end


-- Some characteristics can be many layers deep in the prototypes tree,
-- and it's best to go through them recursively. I use this sparingly
-- as it's better to put a specific change to the value when something
-- is not working right then to try to put an exception here.
---@param object table The object to adjust the properties of
---@param type_name string The type of the object being adjusted
---@param path string The path to the object being adjusted
---@return nil -- No return
local function adjust_prototypes_recursive(object, type_name, path)
	--local skip_all = false

	-- Adjust speeds
	apply_adjustments(object, type_name, path, prototype_speeds_recursive, gtts_time_scale)

	-- Adjust power rates
	apply_adjustments(object, type_name, path, prototype_power_rates_recursive, gtts_time_scale)

	-- Adjust durations
	apply_adjustments(object, type_name, path, prototype_durations_recursive, 1 / gtts_time_scale)

	-- Now recursively work through each sub object of this object, and
	-- adjust animations as necessary, or just pass it on to this function.
	--
	-- Many animations are grouped into layers and the like, the majority
	-- of the purpose of this recursion is to traverse all layers to reach
	-- all of the pieces of the animations.
	--if not skip_all then
		for sub_name, sub_object in pairs(object) do
			-- Don't recursively adjust these objects or anything below them.
			local skip = false
			for _, exclusion in ipairs(exclude_recursive) do
				if sub_name == exclusion then
					skip = true
					break
				end
			end

			-- If we don't skip.
			if not skip then
				if type(sub_object) == "table" then
					-- Here is how animations are identified, as an animation
					-- requires more than one frame.
					if sub_object["frame_count"] then
						if sub_object["frame_count"] > 1 then
							adjust_animation(sub_object)
						end
					else
						--Handle smoke frequency.
						if sub_name == "smoke" then
							for k,_ in ipairs(sub_object) do
								if sub_object[k]["frequency"] then
									sub_object[k]["frequency"] = sub_object[k]["frequency"] * gtts_time_scale
								end
							end
						end
						-- Handle hatches
						if sub_name == "hatch_definitions" then
							for _,hatch in ipairs(sub_object) do
								hatch["busy_timeout_ticks"] = hatch["busy_timeout_ticks"] or 120
								hatch["hatch_opening_ticks"] = hatch["hatch_opening_ticks"] or 80
							end
						end

						-- Handle asteroid probabilities
						if sub_name == "asteroid_spawn_definitions" then
							for _,def in ipairs(sub_object) do
								if def["probability"] then
									def["probability"] = def["probability"] * gtts_time_scale
								end
							end
						end
						if sub_name == "perceived_performance" then
							if sub_object["performance_to_activity_rate"] then
								sub_object["performance_to_activity_rate"] = sub_object["performance_to_activity_rate"] / gtts_time_scale
							end
						end
						if sub_name == "activity_to_speed_modifiers" then
							if sub_object["multiplier"] then
								sub_object["multiplier"] = sub_object["multiplier"] / gtts_time_scale
							end
						end
						if sub_name == "activity_to_volume_modifiers" then
							if sub_object["multiplier"] then
								sub_object["multiplier"] = sub_object["multiplier"] / gtts_time_scale
							end
						end
						if sub_name == "damage_per_tick" then
							if sub_object["amount"] then
								--local initial = sub_object["amount"]
								sub_object["amount"] = sub_object["amount"] * gtts_time_scale
								--log("Object: "..sub_name.." damage adjusted from: "..sub_object["amount"])
							end
						end
						if sub_name == "on_damage_tick_effect" then
							if sub_object["action_delivery"] then
								if sub_object["action_delivery"]["target_effects"] then
									for k,v in ipairs(sub_object["action_delivery"]["target_effects"]) do
										if v["damage"] then
											if v["damage"]["amount"] then
												--local initial = v["damage"]["amount"]
												v["damage"]["amount"] = v["damage"]["amount"] * gtts_time_scale
												--log("Object: "..sub_name.." damage adjusted from: "..v["damage"]["amount"])
											end
										end
									end
								end
							end
						end

						-- Entities with crafting speeds have their own animation
						-- speed control tied to the crafting speed. Since the
						-- crafting speed has already been adjusted, changing the
						-- animation speed will make the animation too fast or too slow.
						local working_animation = false
						if object["crafting_speed"] or object["animation_speed_coefficient"] then
							if sub_name == "working_visualisations"
									or sub_name == "working_visualisations_disabled"
									or sub_name == "animation"
									or sub_name == "idle_animation"
									or sub_name == "graphics_set"
									or sub_name == "graphics_set_flipped" then
								working_animation = true
							end
						end

						--[[
						if object["type"] == "mining-drill" then
							if sub_name == "animations"
									or sub_name == "shadow_animations"
									or sub_name == "input_fluid_patch_shadow_animations"
									or sub_name == "graphics_set"
									or sub_name == "wet_mining_graphics_set" then
								working_animation = true
							end
						end
						--]]

						-- If this is not a working animation, pass it back to this function for further processing.
						if not working_animation then
							local new_path = string.format("%s.%s", path, sub_name)
							adjust_prototypes_recursive(sub_object, type_name, new_path)
						end
					end
				end
			end
		end
	--end
end


-- Adjusts all of the speed and duration related prototype properties based on the settings
---@return nil -- No return
local function adjust_speeds()
	log(string.format("GTTS targeting %s UPS. Started adjusting speeds by: %s and durations by: %s", 60 / gtts_time_scale, gtts_time_scale, (1 / gtts_time_scale)))

	-- Get all prototype types from data.raw
	for type_name, prototype_type in pairs(data.raw) do
		local skip = false

		--Skip any prototype types listed in exclusions
		for _, exclusion in ipairs(exclude_prototype_types) do
			if type_name == exclusion then
				skip = true
				break
			end
		end

		-- Skip attempting to make adjustments if the time scale is the standard time scale
		if gtts_time_scale == 1 then
			skip = true
		end

		-- Don't adjust the properties for prototypes that should be skipped
		if not skip then
			-- Otherwise grab all the prototypes of that type.
			for prototype_name, prototype in pairs(prototype_type) do
				--Check if this is an animation at prototype level.
				local animation = false

				-- Handle weight for non item prototypes only.
				if type_name ~= "item" then
					if prototype["weight"] then
						prototype["weight"] = prototype["weight"] / gtts_time_scale
					end
				end
				if prototype["frame_count"] then
					if prototype["frame_count"] > 1 then
						animation = true
						adjust_animation(prototype)
					end
				end
				if not animation then
					-- Initialize the path string
					local path = string.format("%s.%s", type_name, prototype_name)

					-- Adjust speeds
					apply_adjustments(prototype, type_name, path, prototype_speeds, gtts_time_scale)

					-- Adjust power rates
					apply_adjustments(prototype, type_name, path, prototype_power_rates, gtts_time_scale)

					-- Adjust durations
					apply_adjustments(prototype, type_name, path, prototype_durations, 1 / gtts_time_scale)

					-- Do recursive adjustments
					adjust_prototypes_recursive(prototype, type_name, path)

					-- Construction robots cannot move if their x and y velocities both individually drop below
					-- 2^-8. Thus the safe minimum speed for robots is 2^-8 * sqrt(2) or about 0.0056
					if type_name == "construction-robot" or type_name == "logistic-robot" then
						if prototype["speed"] and prototype["speed_multiplier_when_out_of_energy"] then
							local depleted_speed = prototype["speed"] * prototype["speed_multiplier_when_out_of_energy"]
							-- a speed of 0 means they will crash when out of energy, and we don't want to override that
							if depleted_speed > 0 then
								prototype["speed_multiplier_when_out_of_energy"] = clamp_property(type_name, "speed_multiplier_when_out_of_energy", prototype["speed_multiplier_when_out_of_energy"], 0.0056 / prototype["speed"])
							end
						end
					end

					if type_name == "repair-tool" and prototype["durability"] then
						prototype["durability"] = prototype["durability"] / gtts_time_scale
					end

					-- Fix the doubled impact of vehicle weight changes of platform acceleration.
					if type_name == "utility-constants" then
						if prototype["space_platform_acceleration_expression"] then
							prototype["space_platform_acceleration_expression"] = prototype["space_platform_acceleration_expression"].." * "..gtts_time_scale
						end
					end
				end
			end
		end
	end
	log(string.format("GTTS targeting %s UPS. Finished adjusting speeds by: %s and durations by: %s", 60 / gtts_time_scale, gtts_time_scale, (1 / gtts_time_scale)))
end


-- Start adjusting all the speed and duration properties
adjust_speeds()
