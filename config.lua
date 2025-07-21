-- Time scale values.
gtts_time_scale = 1.0
gtts_time_scale_inverse = 1.0

-- Get the time scale values based on the target frame rate setting.
if settings.startup["gtts-Target-FrameRate"] and settings.startup["gtts-Target-FrameRate"].value >= 6 and settings.startup["gtts-Target-FrameRate"].value <= 480 then
	gtts_time_scale = 60.0 / settings.startup["gtts-Target-FrameRate"].value
	gtts_time_scale_inverse = 1.0 / gtts_time_scale
end

-- This is a list of all the controller types.
controller_names = {
	"editor-controller",
	"god-controller",
	"remote-controller",
	"spectator-controller",
}

-- This is a list of type exclusions that will not be adjusted.
exclude_prototype_types = {
	"mining-tool", -- Mining tool speed is tied in with player mining speed, and the animation rate is tied to the player property.
	"module",
}

-- This is a list of type exclusions that will not be adjusted in the recursive function.
exclude_recursive = {

}

prototype_speeds = {
	--------------------
	-- Factory Speeds --
	--------------------
	"belt_speed", -- Base belt speeds, also affects the belt animation speed.
	"crafting_speed", -- Base crafting speed for factory buildings.
	"mining_speed", -- Mining speed is shared with both mining drills and the player.
	"pumping_speed", -- Liquid pump speeds.
	"researching_speed", -- Lab Research speed.
	"structure_animation_speed_coefficient", -- Animation speed coefficient for splitters and lane splitters.

	-------------------
	-- Player Speeds --
	-------------------
	"distance_per_frame", -- Distance over the ground to travel before moving to the next animation frame.
	"dying_speed", -- How quickly the aliens croak after they reach 0 HP. Perhaps you too.
	"initial_movement_speed",
	"movement_speed", -- Player and other mob movement speeds.
	"running_speed", -- Some mobs use running speed instead of movement speed.

	--------------
	-- Vehicles --
	--------------
	"air-resistance", -- Percent of train speed lost each tick.
	"braking_force", -- Base braking force for trains.
	"friction", -- Friction for cars and tanks as a percent of speed each tick.
	"friction_force", -- Alternate way to define friction.
	"max_speed", -- A variable affecting the speed at which trains will stop accelerating, even if other factors would allow them to go faster.
	"torso_bob_speed", -- Spidertron Torso bob speed.
	"torso_rotation_speed", -- Spidertron Torso rotation speed.
	"train_pushed_by_player_max_speed",
	"turret_rotation_speed", -- Turret rotation speed for cars, tanks, turrets and artillery.

	-------------------
	-- Combat Speeds --
	-------------------
	"attack_speed",
	"attacking_speed",
	"cannon_parking_speed",
	"damage_multiplier_decrease_per_tick",
	"damage_per_tick",
	"ending_attack_speed",
	"folded_speed",
	"folding_speed",
	"prepared_speed",
	"preparing_speed",
	"splash_damage_per_tick",
	"turn_speed",

	----------------------
	-- Pollution Speeds --
	----------------------
	"absorptions_per_second",
	"emissions_per_second",
	"emissions_per_tick", -- Pollution Production.
	"pollution_absorption_absolute", -- How much pollution an entity absorbs each tick no matter how much pollution is in that chunk.
	"pollution_absorption_per_second",
	"pollution_absorption_proportional", -- What percent of the pollution in a chuck the entity will absorb each tick.
	--"absorptions_to_join_attack",
	-- Also see emissions-per-tick under buildings above.

	-----------------
	-- Rocket Silo --
	-----------------
	"door_opening_speed", -- How fast the door opens when the rocket is done building.
	"engine_starting_speed", -- How fast the rocket engine starts.
	"flying_acceleration", -- How fast the rocket accelerates.
	"flying_speed", -- How fast the rocket flies, not sure how it differs from the following.
	"light_blinking_speed", -- How fast the silo lights blink.
	"rising_speed", -- Speed the rocket rises from the silo when done building.

	--------------------------
	-- Miscellaneous Speeds --
	--------------------------
	"ground_patch_fade_in_speed",
	"healing_per_tick", -- Player out of combat healing rate.
	"initial_frame_speed",
	"moving_sound_count_reduction_rate",
	"opening_speed",
	"particle_horizontal_speed",
	"particle_horizontal_speed_deviation",
	"sound_minimum_speed",
	"sound_scaling_ratio",
	"splash_speed",
	"stop_trigger_speed",
	"tree_leaf_distortion_speed_far",
	"tree_leaf_distortion_speed_near",
	"tree_shadow_speed",
	"walking_sound_count_reduction_rate",
	"wave_speed",

	----------------------
	-- Space Age Speeds --
	----------------------
	"arm_angular_speed_cap_base",
	"arm_speed_base",
	"asteroid_spawning_with_random_orientation_max_speed",
	"ejected_item_speed",
	"enraged_speed",
	"gravity_pull",
	"investigating_speed",
	"max_fluid_usage",
	"patrolling_speed",
	"production_health_effect",

	-------------------
	-- Accelerations --
	-------------------
	-- Several acceleration values are doubly affected by time, so set the multiplier exponent to 2 to adjust them twice.
	{
		property = "acceleration",
		multiplier_exponent = 2,
	},
	{
		property = "acceleration_rate",
		multiplier_exponent = 2,
	},
	{
		property = "movement_acceleration",
		multiplier_exponent = 2,
	},
	{
		property = "particle_vertical_acceleration",
		multiplier_exponent = 2,
	},

	--------------------
	-- Special Speeds --
	--------------------
	{
		-- This property is added with a multiplier exponent of 0 so that it is only clamped if it needs to be.
		property = "speed_multiplier_when_out_of_energy",
		multiplier_exponent = 0,
	},
}

prototype_durations = {
	-----------------------
	-- Factory Durations --
	-----------------------
	"asteroid_collector_navmesh_refresh_tick_interval",
	"ejected_item_lifetime",
	"opened_duration",
	"robot_opened_duration",
	"space_platform_dump_cooldown",
	"spoil_ticks",
	"timeout_to_close",

	----------------------
	-- Combat Durations --
	----------------------
	"damage_interval",
	"distraction_cooldown",
	"duration_in_ticks",
	"early_death_ticks",
	"enraged_duration",
	"jump_delay_ticks", -- Tesla Turret chain property.
	"min_pursue_time",
	"spawning_cooldown",
	"ticks_to_keep_aiming_direction",
	"ticks_to_keep_gun",
	"ticks_to_stay_in_combat",
	"time_before_shading_off",
	"time_to_capture",
	"time_to_live",
	"turn_after_shooting_cooldown",
	"turret_return_timeout",

	----------------------------------------------------
	-- Explosion / Fire / Particles / Smoke Durations --
	----------------------------------------------------
	"action_cooldown",
	"add_fuel_cooldown",
	"burning_cooldown",
	"burnt_patch_lifetime",
	"delay_between_initial_flames",
	"fade_away_duration",
	"fade_in_duration",
	"fade_out_duration",
	"glow_fade_away_duration",
	"initial_lifetime",
	"life_time",
	"lifetime_increase_cooldown",
	"maximum_lifetimie",
	"particle_alpha_blend_duration",
	"particle_fade_out_duration",
	"particle_spawn_interval",
	"particle_spawn_timeout",
	"secondary_picture_fade_out_duration",
	"secondary_picture_fade_out_start",
	"smoke_fade_in_duration",
	"smoke_fade_out_duration",
	"spread_delay",
	"spread_duration",

	-----------------------------
	-- Miscellaneous Durations --
	-----------------------------
	"alert_after_time",
	"animation_ticks_per_frame",
	"decay_frame_transition_duration",
	"effect_animation_period",
	"effect_animation_period_deviation",
	"effect_duration",
	"environment_sounds_transition_fade_in_ticks",
	"fade_in_out_ticks",
	"ground_patch_fade_in_delay",
	"ground_patch_fade_out_duration",
	"ground_patch_fade_out_start",
	"overlay_start_delay",
	"repeat_delay",
	"structure_animation_movement_cooldown",
	"time_before_removed",
	"time_to_damage",
	"train_inactivity_wait_condition_default",
	"train_temporary_stop_wait_time",
	"train_time_wait_condition_default",

	-----------------------
	-- Special Durations --
	-----------------------
	{
		property = "durability",
		restrictions = 'root_type == "repair-tool"',
	},
	{
		-- Fix the doubled impact of vehicle weight changes of platform acceleration.
		property = "space_platform_acceleration_expression",
		is_math_expression = true,
	},
	{
		-- Weight has a big impact on how vehicles move. At low frame rates, vehicles will be considered to be moving at
		-- substantial speeds relative to their normal speeds. The energy needed to accelerate their normal weight to
		-- those speeds would be very large as the energy goes up 4x for each 2x increase in speed. Dropping the weight
		-- keeps the ratio inline, and allows the simulation of vehicles to be fairly similar given the change in sampling rate.
		-- 2.0 added weight property to all items to determine how many can fit on a rocket, so this has to be handled
		-- differently for different prototype types.
		-- Handle weight for non item prototypes only.
		property = "weight",
		restrictions = 'root_type == "space-platform-hub" or root_type == "tile" or root_type == "artillery-wagon" or root_type == "cargo-wagon"\
				or root_type == "infinity-cargo-wagon" or root_type == "fluid-wagon" or root_type == "locomotive" or root_type == "spider-vehicle" or root_type == "car"',
	},

	--------------------------------------
	-- Removed due to incompatibilities --
	--------------------------------------
	--"flow_length_in_ticks", -- Causes crashes in some situations at low target frame rates.
	--"request_to_open_door_timeout", -- Causes robots to get stuck at low target frame rates.
}

prototype_power_rates = {
	------------------------
	-- Energy Consumption --
	------------------------
	"active_energy_usage",
	"consumption",
	"crane_energy_usage",
	"energy_consumption",
	"energy_per_tick",
	"energy_usage",
	"energy_usage_per_tick",
	"idle_energy_usage",
	"lamp_energy_usage",
	"movement_energy_consumption",
	"passive_energy_usage",

	-----------------------
	-- Energy Production --
	-----------------------
	"energy_production",
	"production",

	---------------------
	-- Energy Transfer --
	---------------------
	"charging_energy",

	-------------------
	-- Energy Limits --
	-------------------
	"braking_power",
	"max_power",
	"power",

	-------------------
	-- Miscellaneous --
	-------------------
	"heating_energy",
}

prototype_power_rates_recursive = {
	---------------------
	-- Energy Transfer --
	---------------------
	"drain",
	"input_flow_limit",
	"max_transfer",
	"output_flow_limit",
}

-- Mostly these properties are here because they relate to smoke which can be generated
-- at a great many different layers in the prototype tree.
--
-- Entries with a * indicate tables of values, such as those for emissions.
prototype_speeds_recursive = {
	--------------------------------------
	-- Animation / Visualization Speeds --
	--------------------------------------
	"frame_main_scanner_movement_speed",

	--------------------
	-- Factory Speeds --
	--------------------
	"emissions_per_minute",
	"extension_speed", -- Speed at which inserters and agricultural towers extend or contract their hand or crane to reach and place or pick up items.
	"fluid_usage",
	"fluid_usage_per_tick", -- Steam engine and turbine steam usage speed.
	"horizontal_turn_rate",
	"rotation_speed", -- Turing rate for cars and tanks, as well as turning speed for inserters and radars.
	"turn_rate", -- Speed at which agricultural towers turn.
	"vertical_turn_rate",
	--"pollution",

	--------------------------
	-- Miscellaneous Speeds --
	--------------------------
	"frame_speed",
	"initial_vertical_speed",
	"lightnings_per_chunk_per_tick",
	"minimal_change_per_tick",
	"speed", -- Many prototypes have a speed for movement speed, operating speed, etc.
	"speed_from_center",
	"starting_speed",
	"starting_vertical_speed",
	--"gravity",
	--"starting_frame_speed",

	--------------------
	-- Special Speeds --
	--------------------
	{
		property = "amount",
		restrictions = 'path_contains({ "on_damage_tick_effect", "action_delivery", "target_effects", "damage" }) or path_contains("damage_per_tick")',
	},
	{
		property = "animation_speed",
		-- The procession graphic catalogue is for the rocket launch and cargo pod animations.
		-- The animations are already adjusted by adjusting the other related properties, so do not adjust again it here.
		restrictions = 'not path_contains("procession_graphic_catalogue")',
	},
	{
		property = "frequency",
		restrictions = 'path_contains("smoke")',
	},
	{
		property = "probability",
		restrictions = 'path_contains("asteroid_spawn_definitions")',
	},
}

prototype_durations_recursive = {
	-----------------------------------------
	-- Planet / Space Transition Durations --
	-----------------------------------------
	"draw_switch_tick",
	"end_time",
	"flight_duration",
	"impostor_start_tick",
	"intermezzo_max_duration",
	"intermezzo_min_duration",
	"platform_to_planet_duration_a",
	"platform_to_planet_duration_b",
	"platform_to_planet_hatch_open",
	"rocket_separation_end_tick",
	"rocket_separation_tick",
	"solo_duration",
	"special_action_tick",
	"start_time",
	"timestamp",

	-----------------------
	-- Factory Durations --
	-----------------------
	"busy_timeout_ticks",
	"charge_cooldown",
	"discharge_cooldown",
	"hatch_opening_ticks",

	----------------------
	-- Combat Durations --
	----------------------
	"demolisher_cloud_duration",
	"demolisher_expanding_cloud_interval",
	"fissure_eruption_ticks",
	"fissure_explosion_damage_delay_ticks",
	"fissure_explosion_particles_delay_ticks",
	"slow_seconds",
	"warmup",
	--"fissure_explosion_delay_ticks",

	---------------------
	-- Sound Durations --
	---------------------
	"fade_in_ticks",
	"fade_out_ticks",
	"fade_ticks", -- Sound related.
	"music_transition_fade_in_ticks",
	"music_transition_fade_out_ticks",
	"music_transition_pause_ticks",

	-------------------------
	-- Animation Durations --
	-------------------------
	"ease_in_duration",
	"ease_out_duration",

	-----------------------------
	-- Miscellaneous Durations --
	-----------------------------
	"cooldown",
	"delay",
	"duration",
	--"distance_cooldown",

	-----------------------
	-- Special Durations --
	-----------------------
	{
		property = "multiplier",
		restrictions = 'path_contains("activity_to_speed_modifiers") or path_contains("activity_to_volume_modifiers")',
	},
	{
		property = "performance_to_activity_rate",
		restrictions = 'path_contains("perceived_performance")',
	},
}

-- This could be a table, but this makes it more readable below, and the locals are immediately discarded anyway.
local int8   = { min = -2^7, max = 2^7-1 } -- -128 <= x <= 127
local int16  = { min = -2^15, max = 2^15-1 } -- -32,768 <= x <= 32,767
local int32  = { min = -2^31, max = 2^31-1 } -- -2,147,483,648 <= x <= 2,147,483,647
local int64  = { min = -2^63, max = 2^63-1 } -- Unused, but defined in docs, -9,223,372,036,854,775,808 <= x <= 9,223,372,036,854,775,807
local uint8  = { min = 0, max = 2^8-1 } -- 0 <= x <= 255
local uint16 = { min = 0, max = 2^16-1 } -- 0 <= x <= 65,535
local uint32 = { min = 0, max = 2^32-1 } -- 0 <= x <= 4,294,967,295
local uint64 = { min = 0, max = 2^64-1 } -- 0 <= x <= 18,446,744,073,709,551,615

-- List of default values for optional properties related to speed and duration.
-- All of these values are sourced from the API documentation.
prototype_values_default = {
	["animation"] = {
		properties = {
			["animation_speed"] = 1,
		},
		restrictions = 'object["frame_count"] or object["stripes"] or object["slice"] or object["run_mode"] or object["max_advance"] or object["frame_sequence"]',
	},
	["artillery-flare"] = {
		["early_death_ticks"] = 180,
		["initial_frame_speed"] = 1,
	},
	["artillery-turret"] = {
		["cannon_parking_speed"] = 1,
	},
	["artillery-wagon"] = {
		["cannon_parking_speed"] = 1,
	},
	["asteroid-collector"] = {
		["arm_angular_speed_cap_base"] = 0.1,
		["arm_speed_base"] = 0.1,
	},
	["car"] = {
		["turret_return_timeout"] = 60,
		["turret_rotation_speed"] = 0.01,
	},
	["capture-robot"] = {
		["capture_speed"] = 1,
	},
	["character"] = {
		["crafting_speed"] = 1,
		["flying_bob_speed"] = 1,
		["respawn_time"] = 10,
	},
	["corpse"] = {
		["dying_speed"] = 1,
		["splash_speed"] = 1,
		["time_before_removed"] = 60 * 120,
		["time_before_shading_off"] = 60 * 15,
	},
	["fire"] = {
		["add_fuel_cooldown"] = 10,
		["burnt_patch_lifetime"] = 1800,
		["delay_between_initial_flames"] = 10,
		["fade_in_duration"] = 30,
		["fade_out_duration"] = 30,
		["initial_lifetime"] = 300,
		["lifetime_increase_cooldown"] = 10,
		["maximum_lifetime"] = uint32.max,
		["secondary_picture_fade_out_duration"] = 30,
		["smoke_fade_in_duration"] = 30,
		["smoke_fade_out_duration"] = 30,
	},
	["lab"] = {
		["researching_speed"] = 1,
	},
	["land-mine"] = {
		["timeout"] = 120,
		["trigger_interval"] = 10,
	},
	["lane-splitter"] = {
		["animation_speed_coefficient"] = 1,
		["structure_animation_movement_cooldown"] = 10,
		["structure_animation_speed_coefficient"] = 1,
	},
	["linked-belt"] = {
		["animation_speed_coefficient"] = 1,
	},
	["loader"] = {
		["animation_speed_coefficient"] = 1,
	},
	["loader-1x1"] = {
		["animation_speed_coefficient"] = 1,
	},
	["optimized-particle"] = {
		["vertical_acceleration"] = -0.004,
	},
	["projectile"] = {
		["turn_speed"] = 1,
	},
	["pump"] = {
		["fluid_wagon_connector_speed"] = 1 / 64.0,
	},
	["radar"] = {
		["rotation_speed"] = 0.01,
	},
	["roboport"] = {
		["robot_vertical_acceleration"] = 0.01,
	},
	["roboport-equipment"] = {
		["robot_vertical_acceleration"] = 0.01,
	},
	["rocket-silo"] = {
		["launch_wait_time"] = 120,
		["rocket_rising_delay"] = 30,
	},
	["segmented-unit"] = {
		["ticks_per_scan"] = 120,
		["roar_probability"] = 1.0 / (6.0 * 60.0),
	},
	["smoke-with-trigger"] = {
		["cyclic"] = false,
		["movement_slow_down_factor"] = 0.995,
	},
	["speech-bubble"] = {
		["fade_in_out_ticks"] = 60,
	},
	["spider-unit"] = {
		["min_pursue_time"] = 600,
		["torso_bob_speed"] = 1,
		["torso_rotation_speed"] = 1,
	},
	["spider-vehicle"] = {
		["torso_bob_speed"] = 1,
		["torso_rotation_speed"] = 1,
	},
	["splitter"] = {
		["animation_speed_coefficient"] = 1,
		["structure_animation_movement_cooldown"] = 10,
		["structure_animation_speed_coefficient"] = 1,
	},
	["sticker"] = {
		["damage_interval"] = 1,
		["fire_spread_cooldown"] = 30,
	},
	["stream"] = {
		["particle_fade_out_duration"] = uint16.max,
	},
	["transport-belt"] = {
		["animation_speed_coefficient"] = 1,
	},
	["tree"] = {
		["healing_per_tick"] = 0.001666,
	},
	["trivial-smoke"] = {
		["cyclic"] = false,
		["movement_slow_down_factor"] = 0.995,
	},
	["turret"] = {
		["attacking_speed"] = 1,
		["default_speed"] = 1,
	},
	["ammo-turret"] = {
		["attacking_speed"] = 1,
		["default_speed"] = 1,
	},
	["electric-turret"] = {
		["attacking_speed"] = 1,
		["default_speed"] = 1,
	},
	["fluid-turret"] = {
		["attacking_speed"] = 1,
		["default_speed"] = 1,
	},
	["underground-belt"] = {
		["animation_speed_coefficient"] = 1,
	},
	["unit"] = {
		["min_pursue_time"] = 600,
		["rotation_speed"] = 0.025,
	},
}

-- List of default values for optional properties that are nested in deeper layers of the prototype tree.
-- All of these values are sourced from the API documentation.
prototype_values_default_recursive = {
	["activity_to_speed_modifiers"] = {
		["multiplier"] = 1,
	},
	["activity_to_volume_modifiers"] = {
		["multiplier"] = 1,
	},
	["animations"] = {
		properties = {
			["smoke_cycles_per_tick"] = 1,
		},
		restrictions = 'object["idle_with_gun"]',
	},
	["arm"] = {
		["turn_rate"] = 0.01,
		["extension_speed"] = 0.05,
	},
	["capsule_action"] = {
		properties = {
			["timeout"] = 3600,
		},
		restrictions = 'object["type"] == "destroy-cliffs"',
	},
	["grappler"] = {
		["vertical_turn_rate"] = 0.01,
		["horizontal_turn_rate"] = 0.01,
		["extension_speed"] = 0.01,
	},
	["hatch_definitions"] = {
		["busy_timeout_ticks"] = 120,
		["hatch_opening_ticks"] = 80,
	},
	["light_flicker"] = {
		["border_fix_speed"] = 0.02,
	},
	["perceived_performance"] = {
		["performance_to_activity_rate"] = 1,
	},
	["shell_particle"] = {
		["speed"] = 0.1,
	},
	["smoke"] = {
		properties = {
			["vertical_speed_slowdown"] = 0.965,
		},
		restrictions = 'object["frequency"]',
	},
	["smoke_in_air"] = {
		properties = {
			["vertical_speed_slowdown"] = 0.965,
		},
		restrictions = 'object["frequency"]',
	},
	["smoke_sources"] = {
		properties = {
			["vertical_speed_slowdown"] = 0.965,
		},
		restrictions = 'object["frequency"]',
	},
	["space_dust_background"] = {
		["animation_speed"] = 1,
	},
	["space_dust_foreground"] = {
		["animation_speed"] = 1,
	},

	----------------------
	-- Special Defaults --
	----------------------
	-- Some properties that should have default values have a lot of objects they can belong to, such as animations.
	-- For these, we can use this special wildcard object. This is computationally more expensive, but is fine if used for only a few properties.
	["*"] = {
		properties = {
			["animation_speed"] = 1,
		},
		restrictions = 'object["frame_count"] or object["stripes"] or object["slice"] or object["run_mode"] or object["max_advance"] or object["frame_sequence"]',
	},
}

-- Max clamp values for properties.
-- Keys can be just the property_name, root_type.property_name, or object.property_name. The latter have precedence.
prototype_values_clamp_high = {
	["artillery-projectile.ease_out_duration"] = uint8.max,
	["explosion.fade_out_duration"] = uint8.max,
	["fire.fade_out_duration"] = uint32.max, -- Shared name with different cap, so defined by type.
	["projectile.ease_out_duration"] = uint8.max,
	damage_interval = uint32.max,
	duration_in_ticks = uint32.max,
	flicker_interval = uint8.max,
	life_time = uint16.max,
	spoil_ticks = uint32.max,
	time_before_removed = uint32.max,
	time_to_live = uint32.max,

	-------------------------
	-- Special High Clamps --
	-------------------------
	animation_speed = {
		{
			-- Some smoke prototypes require that frame_count / animation_speed be greater than 1 if the smoke isn't cyclical.
			-- In those cases, set the animation speed high clamp to just under the frame_count.
			limit = { "X - 0.000001", { ["X"] = "frame_count" } },
			restrictions = 'object["frame_count"] and root_object["cyclic"] == false',
		},
	},
	duration = {
		{
			-- For camera effects and working visualization states, the duration has a lower clamp value.
			limit = uint8.max,
			restrictions = 'object["type"] == "camera-effect" or path_contains("states")',
		},
		{
			-- Standard clamp for all other duration properties.
			limit = uint32.max,
		},
	},
}

-- Min clamp values for properties.
-- Keys can be just the property_name, root_type.property_name, or object.property_name. The latter have precedence.
prototype_values_clamp_low = {
	duration = 1,
	duration_in_ticks = 1,

	------------------------
	-- Special Low Clamps --
	------------------------
	speed_multiplier_when_out_of_energy = {
		{
			-- Construction robots cannot move if their x and y velocities both individually drop below 2^-8.
			-- Thus the safe minimum speed for robots is 2^-8 * sqrt(2) or about 0.0056.
			limit = { "0.0056 / X", { ["X"] = "speed" } },
			-- A speed multiplier of 0 means they will crash when out of energy, and we don't want to override that.
			restrictions = 'object["speed_multiplier_when_out_of_energy"] ~= 0',
		},
	},
}

-- Controller speed value needs a different clamping value than other prototypes, so handle them separately.
for _, controller in ipairs(controller_names) do
	local new_clamp = string.format("%s.%s", controller, "movement_speed")
	prototype_values_clamp_low[new_clamp] = prototype_values_clamp_low[new_clamp] or 0.34375
end
