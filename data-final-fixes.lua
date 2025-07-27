-- Global configuration table
require("config")

-- Add compatibility prototypes
require("prototypes.compatibility")

-- Table of references to tables previously adjusted
local table_references = {} ---@type table

-- Table of references to functions created with load()
local load_functions = {} ---@type table

-- Global variables for use by functions created with load()
g_object = nil		---@type table
g_object_root = nil	---@type table
g_object_name = nil	---@type string
g_root_type = nil	---@type string
local g_path = nil	---@type string


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
-- This is a global function so it can be used by functions created with load()
---@param str string The string to check the ending of
---@param ending string	The string to check as the ending
---@return boolean -- Whether the string has the ending or not
function string_ends_with(str, ending)
	-- Verify the parameters are strings
	if type(str) ~= "string" or type(ending) ~= "string" then
		return false
	end

	-- Determine if the given string has the given ending
	return string.sub(str, -#ending) == ending
end


-- Utility function to determine if the path string contains a specific entry
-- This is a global function so it can be used by functions created with load()
---@param entry string|table The string or table of strings to check existence of in the path
---@return boolean -- Whether the path contains the entry or not
function path_contains(entry)
	-- Place a period on both sides of the string to prevent entries accidentally matching another part of the path
	g_path = util.string_starts_with(g_path, ".") and g_path or string.format(".%s.", g_path)

	-- If this is a table, then check if every entry in it is in the path
	if type(entry) == "table" then
		for _, v in ipairs(entry) do
			-- Verify the entry is a string
			if type(v) ~= "string" then
				return false
			end

			-- Determine if the entry is not in the path, and return false if that is the case
			local str = string.format(".%s.", v)
			if not string.find(g_path, str, 1, true) then
				return false
			end
		end

		-- At this point, all entries have successfully matched, so return true
		return true
	end

	-- Verify the entry is a string
	if type(entry) ~= "string" then
		return false
	end

	-- Determine if the entry is in the path and return the result
	local str = string.format(".%s.", entry)
	return string.find(g_path, str, 1, true) ~= nil
end


-- Checks if all the restrictions for adjusting a prototype are satisfied
---@param object_name string The name of the object
---@param object table The object itself
---@param root_type string The root type of the object
---@param root_object table The root object itself
---@param path string The path to the object
---@param restrictions string? The list of restrictions to check
---@return boolean -- Whether all the restrictions are satisfied or not
local function check_restrictions(object_name, object, root_type, root_object, path, restrictions)
	-- If there are no restrictions, then the restrictions are automatically satisfied, so return true
	if not restrictions then
		return true
	end

	-- Set the global variables to the values in the parameters
	-- This is done because the function created by the load function can only use global variables
	g_object = object
	g_object_name = object_name
	g_object_root = root_object
	g_root_type = root_type
	g_path = path

	-- Get the cached version of the function if it exists
	local func = load_functions[restrictions]

	-- If there was no cached version, then make a new function for the given restriction
	if not func then
		-- Format the restriction string for use by load()
		-- For ease of writing the restrictions, simple names are used for writing and are then converted here to the specific global names for use by load()
		local str = restrictions
		str = string.gsub(str, "root_type", "g_root_type")
		str = string.gsub(str, "root_object", "object_root") -- The "g_" prefix will be added by the next line
		str = string.gsub(str, "object", "g_object") -- Done at the end to prevent causing issues earlier
		str = string.format("return (%s)", str) -- A return statement is necessary to get the result of the function

		-- Create the new function with formatted string
		func = load(str)

		-- Cache the new function for later use to save performance time
		load_functions[restrictions] = func
	end

	-- Executing the function gives the result of whether the restrictions were met, so return it immediately
	return func and func() or false
end


-- Gets the first limit value from a clamp data table that meets the requirements, or nil if none
---@param object_name string The name of the object that the property belongs to
---@param object table The object that the property belongs to
---@param root_type string The root type name of the object that the property belongs to
---@param root_object table The root object that this object belongs to
---@param path string The path to the current property
---@param clamp_data table The table of limits and restrictions
---@return number? -- The first valid clamp value from the clamp data
local function get_clamp_value(object_name, object, root_type, root_object, path, clamp_data)
	-- Iterate over all the limits in the table
	for _, entry in ipairs(clamp_data) do
		-- Check if this object meets the restrictions for this limit to be used
		if check_restrictions(object_name, object, root_type, root_object, path, entry.restrictions) then
			-- If the limit is just a standard value, return that value
			local limit = entry.limit
			if type(limit) ~= "table" then
				return limit
			end

			-- If the limit is a table, then this is an expression limit
			-- Substitute the variables with the appropriate values
			local variables = {}
			for k, v in pairs(limit[2]) do
				variables[k] = object[v]
			end

			-- Return the evaluated expression
			return helpers.evaluate_expression(limit[1], variables)
		end
	end
end


-- Clamps the given prototype property to the range set in config.lua
---@param object_name string The name of the object that the property belongs to
---@param object table The object that the property belongs to
---@param root_type string The root type name of the object that the property belongs to
---@param root_object table The root object that this object belongs to
---@param full_path string The full path to the current property
---@param property string The name of the property being clamped
---@param base_value number The current value of the property
---@param min_value number? The minimum value to clamp to (inclusive)
---@param max_value number? The maximum value to clamp to (inclusive)
---@return number -- The property value clamped to `min <= x <= max`
local function clamp_property(object_name, object, root_type, root_object, full_path, property, base_value, min_value, max_value)
	-- Get the paths that will be checked
	local root_path = string.format("%s.%s", root_type, property)
	local object_path = string.format("%s.%s", object_name, property)

	-- Get the minimum and maximum values for this property
	min_value = min_value or prototype_values_clamp_low[object_path] or prototype_values_clamp_low[root_path] or prototype_values_clamp_low[property] or math.huge * -1
	max_value = max_value or prototype_values_clamp_high[object_path] or prototype_values_clamp_high[root_path] or prototype_values_clamp_high[property] or math.huge

	-- If the min value is a table, then get the actual min value from the table
	if type(min_value) == "table" then
		min_value = get_clamp_value(object_name, object, root_type, root_object, full_path, min_value) or math.huge * -1
	end

	-- If the max value is a table, then get the actual max value from the table
	if type(max_value) == "table" then
		max_value = get_clamp_value(object_name, object, root_type, root_object, full_path, max_value) or math.huge
	end

	-- Clamp the property value if necessary
	local ret = math.min(math.max(base_value, min_value), max_value)

	-- If the value was clamped, make a note in the log file
	if ret ~= base_value then
		--log(string.format("CLAMPED: %s.%s,  %s -> %s", full_path, property, base_value, ret))
	end

	-- Return the clamped value
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


-- Sets the given list of default property values to the given object, if the restrictions for those defaults are satisfied
---@param object_name string The name of the object to set defaults for
---@param object table The object itself
---@param root_type string The root type of the object to set defaults for
---@param root_object table The root object itself
---@param path string The path to the object to set defaults for
---@param properties table? The list of default property values to apply
---@param restrictions string? The list of restrictions to check
---@param i integer? The index of the entry if the entry is part of an array
---@return nil -- No return
local function apply_defaults(object_name, object, root_type, root_object, path, properties, restrictions, i)
	-- Return immediately if there are no default values to set, the object isn't a table, or the restrictions are not met
	if not properties or type(object) ~= "table" or not check_restrictions(object_name, object, root_type, root_object, path, restrictions) then
		return
	end

	-- Ensure all optional properties are set
	for k, v in pairs(properties) do
		-- If this is a table of default property values, set the default values in this table
		if type(v) == "table" and v.properties then
			if check_restrictions(object_name, object, root_type, root_object, path, v.restrictions) then
				for sub_k, sub_v in pairs(v.properties) do
					if object[sub_k] == nil then
						object[sub_k] = object[sub_k] or sub_v
						--log(string.format("Set default value of %s for %s at %s%s", sub_v, sub_k, path, i and "." .. i or ""))
					end
				end
			end
		elseif object[k] == nil then
			object[k] = object[k] or v
			--log(string.format("Set default value of %s for %s at %s%s", v, k, path, i and "." .. i or ""))
		end
	end
end


-- Sets all the default property values for the given object as defined in the config.lua file
---@param object_name string The name of the object to set defaults for
---@param object table The object itself
---@param root_type string The root type of the object to set defaults for
---@param root_object table The root object itself
---@param path string The path to the object to set defaults for
---@param property_list table The list of default property values to check and apply
---@return nil -- No return
local function set_defaults(object_name, object, root_type, root_object, path, property_list)
	-- Get the property defaults and restrictions for the current object
	local object_properties = property_list[object_name] and property_list[object_name].properties or property_list[object_name] or nil
	local object_restrictions = property_list[object_name] and property_list[object_name].restrictions or nil

	-- Get the special defaults and restrictions for the current object
	local special_properties = property_list["*"] and property_list["*"].properties or property_list["*"] or nil
	local special_restrictions = property_list["*"] and property_list["*"].restrictions or nil

	-- If this is an array, set the default values for each entry in the array
	if is_array(object) then
		local num_repeat_count = 0
		local check_animation = type(object[1]) == "table" and not object[1]["layers"] and not object[1]["animation_speed"]
		for i, entry in ipairs(object) do
			-- Apply the default values
			apply_defaults(object_name, entry, root_type, root_object, path, object_properties, object_restrictions, i)
			apply_defaults(object_name, entry, root_type, root_object, path, special_properties, special_restrictions, i)

			-- Also check if a default animation speed value should be applied
			if check_animation and type(entry) == "table" then
				-- If any of these properties are present, this is an animation
				if entry["frame_count"] or entry["stripes"] or entry["slice"] or entry["run_mode"] or entry["max_advance"] or entry["frame_sequence"] or entry["animation_speed"] then
					object[1]["animation_speed"] = object[1]["animation_speed"] or 1
					check_animation = false

				-- If "repeat_count" is present at least twice, then this is an animation
				elseif entry["repeat_count"] and (entry["filename"] or entry["filenames"]) then
					num_repeat_count = num_repeat_count + 1
					if num_repeat_count >= 2 then
						object[1]["animation_speed"] = object[1]["animation_speed"] or 1
						check_animation = false
					end
				end
			end
		end
	else
		-- Apply the default values
		apply_defaults(object_name, object, root_type, root_object, path, object_properties, object_restrictions)
		apply_defaults(object_name, object, root_type, root_object, path, special_properties, special_restrictions)
	end
end


-- Adjust the property values of the given object by the given multiplier
---@param object_name string The name of the object being adjusted
---@param object table The object to adjust the properties of
---@param root_type string The root type of the object being adjusted
---@param root_object table The root object itself
---@param path string The path to the object being adjusted
---@param property_list table The list of properties to adjust
---@param multiplier number The multiplier to adjust the properties by
---@return nil -- No return
local function apply_adjustments(object_name, object, root_type, root_object, path, property_list, multiplier)
	-- Iterate over all the properties in the given property list
	for _, property in ipairs(property_list) do
		-- Set or reset these variables for use later by this function
		local restrictions = nil
		local final_multiplier = multiplier
		local is_math_expression = false
		local offset = 0

		-- If the current entry in the property list is a table, then get the actual property from it along with any additional data it may have
		if type(property) == "table" then
			restrictions = property.restrictions
			final_multiplier = multiplier ^ (property.multiplier_exponent or 1)
			is_math_expression = property.is_math_expression or false
			offset = property.offset or 0
			property = property.property
		end

		-- Check that the object has the property, that it hasn't already been adjusted, and that it meets all the restrictions (if any)
		if object[property] and (not table_references[object] or not table_references[object][property]) and check_restrictions(object_name, object, root_type, root_object, path, restrictions) then
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
					object[property][k] = clamp_property(object_name, object, root_type, root_object, path, property, ((object[property][k] - offset) * final_multiplier) + offset)
					--log(string.format("Adjusted property \"%s.%s\" from %s to %s at path: %s", property, k, v, object[property][k], path))
				end

			-- If the property is a number, then simply multiply it by the multiplier
			elseif type(object[property]) == "number" then
				local initial = object[property]
				object[property] = clamp_property(object_name, object, root_type, root_object, path, property, ((object[property] - offset) * final_multiplier) + offset)
				--log(string.format("Adjusted property \"%s\" from %s to %s at path: %s", property, initial, object[property], path))

			-- If the property is a string and is set as a math expression, then just concatenate the multiplier to the end of the string
			elseif type(object[property]) == "string" and is_math_expression then
				local initial = object[property]
				object[property] = string.format(("%s * %s"), object[property], final_multiplier)
				--log(string.format("Adjusted property \"%s\" from %s to %s at path: %s", property, initial, object[property], path))

			-- If the property is a string and the property list is one of the power rate lists, then use the adjust energy function to modify the property value
			elseif type(object[property]) == "string" and (string_ends_with(object[property], "W") or string_ends_with(object[property], "J")) then
				local initial = object[property]
				object[property] = adjust_energy(object[property], final_multiplier)
				--log(string.format("Adjusted property \"%s\" from %s to %s at path: %s", property, initial, object[property], path))
			end
		end
	end
end


-- Some characteristics can be many layers deep in the prototypes tree,
-- and it's best to go through them recursively. I use this sparingly
-- as it's better to put a specific change to the value when something
-- is not working right then to try to put an exception here.
---@param object_name string The name of the object being adjusted
---@param object table The object to adjust the properties of
---@param root_type string The root type of the object being adjusted
---@param root_object table The root object itself
---@param path string The path to the object being adjusted
---@return nil -- No return
local function adjust_prototypes_recursive(object_name, object, root_type, root_object, path)
	-- Set defaults
	set_defaults(object_name, object, root_type, root_object, path, prototype_values_default_recursive)

	-- Adjust speeds
	apply_adjustments(object_name, object, root_type, root_object, path, prototype_speeds_recursive, gtts_time_scale)

	-- Adjust power rates
	apply_adjustments(object_name, object, root_type, root_object, path, prototype_power_rates_recursive, gtts_time_scale)

	-- Adjust durations
	apply_adjustments(object_name, object, root_type, root_object, path, prototype_durations_recursive, 1 / gtts_time_scale)

	-- If the skip_all flag is set or if this object had an animation speed, then do not continue the recursion
	-- For animation speeds, there is nothing else to adjust from here, so we stop the recursion for performance
	local skip_all = false
	if skip_all or object["animation_speed"] then
		return
	end

	-- Now recursively work through each sub object of this object
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
		if not skip and type(sub_object) == "table" then
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
				adjust_prototypes_recursive(sub_name, sub_object, root_type, root_object, new_path)
			end
		end
	end
end


-- Adjusts all of the speed and duration related prototype properties based on the settings
---@return nil -- No return
local function adjust_speeds()
	log(string.format("GTTS targeting %s UPS. Started adjusting speeds by: %s and durations by: %s", 60 / gtts_time_scale, gtts_time_scale, (1 / gtts_time_scale)))

	-- Get all prototype types from data.raw
	for type_name, prototype_type in pairs(data.raw) do
		local skip = false

		-- Nerf particle effects if setting is set
		if nerf_particles and type_name == "optimized-particle" then
			gtts_time_scale = gtts_time_scale_extreme
		else
			gtts_time_scale = gtts_time_scale_base
		end

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
				-- Initialize the path string
				local path = string.format("%s.%s", type_name, prototype_name)

				-- Set defaults
				set_defaults(type_name, prototype, type_name, prototype, path, prototype_values_default)

				-- Adjust speeds
				apply_adjustments(type_name, prototype, type_name, prototype, path, prototype_speeds, gtts_time_scale)

				-- Adjust power rates
				apply_adjustments(type_name, prototype, type_name, prototype, path, prototype_power_rates, gtts_time_scale)

				-- Adjust durations
				apply_adjustments(type_name, prototype, type_name, prototype, path, prototype_durations, 1 / gtts_time_scale)

				-- Do recursive adjustments
				adjust_prototypes_recursive(type_name, prototype, type_name, prototype, path)
			end
		end
	end
	log(string.format("GTTS targeting %s UPS. Finished adjusting speeds by: %s and durations by: %s", 60 / gtts_time_scale, gtts_time_scale, (1 / gtts_time_scale)))
end


-- Start adjusting all the speed and duration properties
adjust_speeds()
