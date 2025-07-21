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
	"god-controller",
	"editor-controller",
	"spectator-controller",
	"remote-controller",
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
	"crafting_speed", -- Base crafting speed for factory buildings.
	"belt_speed", -- Base belt speeds, also affects the belt animation speed.
	"mining_speed", -- Mining speed is shared with both mining drills and the player.
	"pumping_speed", -- Liquid pump speeds.
	"emissions_per_tick", -- Pollution Production.
	"fluid_usage_per_tick", -- Steam engine and turbine steam usage speed.
	"rotation_speed", -- Turing rate for cars and tanks, as well as turning speed for inserters and radars.
	"researching_speed", -- Lab Research speed.
	"structure_animation_speed_coefficient", -- Animation speed coefficient for splitters and lane splitters.

	-------------------
	-- Player Speeds --
	-------------------
	"distance_per_frame", -- Distance over the ground to travel before moving to the next animation frame.
	"dying_speed", -- How quickly the aliens croak after they reach 0 HP. Perhaps you too.
	"running_speed", -- Some mobs use running speed instead of movement speed.


	--------------
	-- Vehicles --
	--------------
	"turret_rotation_speed", -- Turret rotation speed for cars, tanks, turrets and artillery.
	"braking_force", -- Base braking force for trains.
	"friction", -- Friction for cars and tanks as a percent of speed each tick.
	"friction_force", -- Alternate way to define friction.
	"air-resistance", -- Percent of train speed lost each tick.
	"torso_rotation_speed", -- Spidertron Torso rotation speed.
	"max_speed", -- A variable affecting the speed at which trains will stop accelerating, even if other factors would allow them to go faster.
	"torso_bob_speed", -- Spidertron Torso bob speed.

	-------------------
	-- Combat Speeds --
	-------------------
	"folded_speed",
	"folding_speed",
	"prepared_speed",
	"preparing_speed",
	"cannon_parking_speed",
	"attack_speed",
	"ending_attack_speed",
	"damage_multiplier_decrease_per_tick",
	"splash_damage_per_tick",


	----------------------
	-- Pollution Speeds --
	----------------------
	"pollution_absorption_absolute", -- How much pollution an entity absorbs each tick no matter how much pollution is in that chunk.
	"pollution_absorption_proportional", -- What percent of the pollution in a chuck the entity will absorb each tick.
	"pollution_absorption_per_second",
	-- Also see emissions-per-tick under buildings above.

	-----------------
	-- Rocket Silo --
	-----------------
	"door_opening_speed", -- How fast the door opens when the rocket is done building.
	"light_blinking_speed", -- How fast the silo lights blink.
	"engine_starting_speed", -- How fast the rocket engine starts.
	"flying_speed", -- How fast the rocket flies, not sure how it differs from the following.
	"flying_acceleration", -- How fast the rocket accelerates.
	"rising_speed", -- Speed the rocket rises from the silo when done building.

	--------------------------
	-- Miscellaneous Speeds --
	--------------------------

	"opening_speed",
	"splash_speed",
	"particle_horizontal_speed",
	"particle_horizontal_speed_deviation",
	"frame_main_scanner_movement_speed",
	"stop_trigger_speed",
	"sound_scaling_ratio",
	"sound_minimum_speed",
	"ground_patch_fade_in_speed",

	----------------------
	-- Space Age Speeds --
	----------------------

	"arm_speed_base",
	"arm_angular_speed_cap_base",
	"production_health_effect",
	"max_fluid_usage",

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
	-- Another timing method for animations.
	"animation_ticks_per_frame",
	"effect_animation_period",
	"effect_animation_period_deviation",

	-- Actual Durations
	"maximum_lifetimie",
	"life_time",
	"initial_lifetime",
	"burnt_patch_lifetime",
	"min_pursue_time",
	"distraction_cooldown",
	--"duration",
	"fade_in_duration",
	"fade_out_duration",
	"fade_in_out_ticks",
	"fade_away_duration",
	"smoke_fade_in_duration",
	"smoke_fade_out_duration",
	"ticks_to_keep_aiming_direction",
	"ticks_to_keep_gun",
	"ticks_to_stay_in_combat",
	"time_before_removed",
	"time_to_live",
	"opened_duration",
	"robot_opened_duration",
	"particle_alpha_blend_duration",
	"spoil_ticks",
	"time_to_damage",
	"effect_duration",
	"time_to_capture",
	"decay_frame_transition_duration",
	"ground_patch_fade_out_duration",

	-- Cooldowns

	"lifetime_increase_cooldown",
	"add_fuel_cooldown",
	"charge_cooldown",
	"discharge_cooldown",
	"structure_animation_movement_cooldown",
	"burning_cooldown",
	"action_cooldown",
	"glow_fade_away_duration",
	"turn_after_shooting_cooldown",

	--Delays

	"spread_delay",
	"delay_between_initial_flames",
	"overlay_start_delay",

	"turret_return_timeout",
	"timeout_to_close",

	"early_death_ticks",
	"damage_interval",

	"alert_after_time",
	"ground_patch_fade_in_delay",
	"ground_patch_fade_out_start",


	"particle_fade_out_duration",

	--"particle_spawn_interval",
	--"particle_spawn_timeout",


	"secondary_picture_fade_out_start",
	"secondary_picture_fade_out_duration",

	"duration_in_ticks",

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
	-- All these have approximately the same meaning.
	"consumption",
	"energy_consumption",
	"idle_energy_usage",
	"energy_usage",
	"energy_per_tick",
	"energy_usage_per_tick",
	"active_energy_usage",
	"lamp_energy_usage",
	"movement_energy_consumption",
	"passive_energy_usage",


	-- Production rather than consumption.
	"production",
	"energy_production",

	-- Moving energy around.
	"charging_energy",

	-- Limits.
	"power",
	"max_power",
	"braking_power",

	-- Misc.
	"heating_energy",
	"crane_energy_usage",
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
	"healing_per_tick", -- Player out of combat healing rate.
	"damage_per_tick",


	"movement_speed", -- Player and other mob movement speeds.

	"speed", -- Many prototypes have a speed for movement speed, operating speed, etc.

	-- The following are mostly related to projectiles, particles and smoke.
	"starting_speed",
	--"starting_frame_speed",
	"starting_vertical_speed",
	"speed_from_center",
	"initial_vertical_speed",
	"initial_frame_speed",
	"initial_movement_speed",
	"frame_speed",
	"emissions_per_minute",
	"emissions_per_second",
	"absorptions_per_second",

	"tree_leaf_distortion_speed_far",
	"tree_leaf_distortion_speed_near",
	"tree_shadow_speed",

	"asteroid_spawning_with_random_orientation_max_speed",
	"ejected_item_speed",

	"train_pushed_by_player_max_speed",
	"walking_sound_count_reduction_rate",
	"moving_sound_count_reduction_rate",

	"fluid_usage",
	"gravity_pull",
	"lightnings_per_chunk_per_tick",
	"minimal_change_per_tick",

	"patrolling_speed",
	"investigating_speed",
	"attacking_speed",
	"enraged_speed",
	"wave_speed",

	--"initial_movement_speed",
	"turn_speed",

	--"absorptions_to_join_attack",
	--"pollution",
	"vertical_turn_rate",
	"horizontal_turn_rate",
	"extension_speed", -- Speed at which inserters extend or contract their hand to pick up items on the other side of belts, or to reach closer or further belts in mods that support it. Also Agricultural Towers.
	"turn_rate",


	--"frequency",
	--"gravity",

	--------------------
	-- Special Speeds --
	--------------------
	{
		property = "amount",
		restrictions = 'path_contains({ "on_damage_tick_effect", "action_delivery", "target_effects", "damage" }) or path_contains("damage_per_tick")',
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

	"fade_in_ticks",
	"fade_out_ticks",

	"particle_spawn_interval",
	"particle_spawn_timeout",

	"ease_in_duration",
	"ease_out_duration",
	"duration",

	"spawning_cooldown",

	"platform_to_planet_duration_a",
	"platform_to_planet_duration_b",
	"platform_to_planet_hatch_open",

	"impostor_start_tick",
	"rocket_separation_tick",
	"rocket_separation_end_tick",
	"flight_duration",
	"solo_duration",

	"special_action_tick",
	"draw_switch_tick",
	"intermezzo_min_duration",
	"intermezzo_max_duration",
	"timestamp",

	"busy_timeout_ticks",
	"hatch_opening_ticks",
	"end_time",
	"start_time",

	"space_platform_dump_cooldown",
	"asteroid_collector_navmesh_refresh_tick_interval",

	"train_temporary_stop_wait_time",
	"train_time_wait_condition_default",
	"train_inactivity_wait_condition_default",

	"ejected_item_lifetime",
	"music_transition_fade_out_ticks",
	"music_transition_pause_ticks",
	"music_transition_fade_in_ticks",
	"environment_sounds_transition_fade_in_ticks",

	"cooldown",
	"delay",
	"time_before_shading_off",
	"spread_duration",
	"repeat_delay",

	"slow_seconds",
	"demolisher_cloud_duration",
	"demolisher_expanding_cloud_interval",
	--"fissure_explosion_delay_ticks",
	"fissure_explosion_particles_delay_ticks",
	"fissure_explosion_damage_delay_ticks",
	"fissure_eruption_ticks",
	"enraged_duration",

	--"distance_cooldown",

	"fade_ticks", -- Sound related.

	"jump_delay_ticks", -- Tesla Turret chain property.
	"warmup",

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
}

-- Max clamp values for properties.
-- Keys can be just the property_name, root_type.property_name, or object.property_name. The latter have precedence.
prototype_values_clamp_high = {
	time_to_live = uint32.max,
	["fire.fade_out_duration"] = uint32.max, -- Shared name with different cap, so defined by type.
	["explosion.fade_out_duration"] = uint8.max,
	damage_interval = uint32.max,
	time_before_removed = uint32.max,
	["artillery-projectile.ease_out_duration"] = uint8.max,
	["projectile.ease_out_duration"] = uint8.max,
	duration_in_ticks = uint32.max,
	life_time = uint16.max,
	spoil_ticks = uint32.max,
	flicker_interval = uint8.max,

	-------------------------
	-- Special High Clamps --
	-------------------------
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
