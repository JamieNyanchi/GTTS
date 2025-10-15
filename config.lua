-- Mod and API names.
gtts_mod_name = "GTTS"
gtts_API_name = "GTTS"

-- Time scale values.
gtts_tick_rate = 60
gtts_time_scale = 1.0
gtts_time_scale_inverse = 1.0

-- Safe mode setting.
gtts_safe_mode = false

-- Nerf particle values.
nerf_particles = false
gtts_time_scale_base = 1.0
gtts_time_scale_extreme = 1.0

-- Get the time scale values based on the target frame rate setting.
if settings.startup["gtts-Target-FrameRate"] and settings.startup["gtts-Target-FrameRate"].value >= 6 and settings.startup["gtts-Target-FrameRate"].value <= 480 then
	gtts_tick_rate = settings.startup["gtts-Target-FrameRate"].value
	gtts_time_scale = 60.0 / gtts_tick_rate
	gtts_time_scale_inverse = 1.0 / gtts_time_scale

	gtts_time_scale_base = gtts_time_scale
end

-- Get whether safe mode is active or not.
if settings.startup["gtts-z-No-Runtime-Adjustments"] then
	gtts_safe_mode = settings.startup["gtts-z-No-Runtime-Adjustments"].value
end

-- Get the time scale values for particles based on the nerf particles setting.
if settings.startup["gtts-Nerf-Particles"] and settings.startup["gtts-Nerf-Particles"].value then
	nerf_particles = settings.startup["gtts-Nerf-Particles"].value
	gtts_time_scale_extreme = 2^64
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
	"belt_speed", -- (?) Base belt speeds, also affects the belt animation speed.
	"crafting_speed", -- Base crafting speed for factory buildings.
	"max_fluid_flow", -- Max fluid flow through entity fluid inputs and outputs.
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
	"braking_force", -- Base braking force for trains.
	"friction", -- Friction for cars and tanks as a percent of speed each tick.
	"friction_force", -- Alternate way to define friction.
	"torso_bob_speed", -- Spidertron Torso bob speed.
	"torso_rotation_speed", -- Spidertron Torso rotation speed.
	"train_pushed_by_player_max_acceleration",
	"train_pushed_by_player_max_speed",
	"train_waiting_at_signal_tick_multiplier_penalty",
	"turret_rotation_speed", -- Turret rotation speed for cars, tanks, turrets and artillery.

	-------------------
	-- Combat Speeds --
	-------------------
	"attack_speed", -- (?)
	"attacking_speed",
	"cannon_parking_speed",
	"damage_multiplier_decrease_per_tick",
	"damage_per_tick",
	"default_speed",
	"default_speed_secondary",
	"default_speed_when_killed",
	"ending_attack_speed",
	"ending_attack_speed_secondary",
	"ending_attack_speed_when_killed",
	"folded_speed",
	"folded_speed_secondary",
	"folded_speed_when_killed",
	"folding_speed",
	"folding_speed_secondary",
	"folding_speed_when_killed",
	"prepared_alternative_speed",
	"prepared_alternative_speed_secondary",
	"prepared_alternative_speed_when_killed",
	"prepared_speed",
	"prepared_speed_secondary",
	"prepared_speed_when_killed",
	"preparing_speed",
	"preparing_speed_secondary",
	"preparing_speed_when_killed",
	"rotation_speed_secondary",
	"rotation_speed_when_killed",
	"splash_damage_per_tick", -- (?)
	"starting_attack_speed",
	"starting_attack_speed_secondary",
	"starting_attack_speed_when_killed",
	"turn_speed",

	----------------------
	-- Pollution Speeds --
	----------------------
	"absorptions_per_second",
	"emissions_per_second",
	"emissions_per_tick", -- (?) Pollution Production.
	"pollution_absorption_absolute", -- (?) How much pollution an entity absorbs each tick no matter how much pollution is in that chunk.
	"pollution_absorption_per_second", -- (?)
	"pollution_absorption_proportional", -- (?) What percent of the pollution in a chuck the entity will absorb each tick.
	--"absorptions_to_join_attack",
	-- Also see (?) emissions-per-tick under buildings above.

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
	"fluid_wagon_connector_speed",
	"ground_patch_fade_in_speed",
	"healing_per_tick", -- Player out of combat healing rate.
	"initial_frame_speed",
	"mining_particle_frame_speed",
	"moving_sound_count_reduction_rate",
	"opening_speed",
	"particle_horizontal_speed",
	"particle_horizontal_speed_deviation",
	"scale_increment_per_tick",
	"sound_minimum_speed", -- (?)
	"sound_scaling_ratio", -- (?)
	"splash_speed",
	"stop_trigger_speed",
	"tree_leaf_distortion_speed_far",
	"tree_leaf_distortion_speed_near",
	"tree_shadow_speed",
	"walking_sound_count_reduction_rate",
	"wave_speed",
	--"horizontal_speed",
	--"horizontal_speed_deviation",

	----------------------
	-- Space Age Speeds --
	----------------------
	"arm_angular_speed_cap_base",
	"arm_speed_base",
	"asteroid_spawning_with_random_orientation_max_speed",
	"capture_speed",
	"ejected_item_speed",
	"enraged_speed",
	"gravity_pull",
	"investigating_speed",
	"max_fluid_usage",
	"patrolling_speed",
	"production_health_effect",
	"roar_probability",
	"space_platform_asteroid_chunk_trajectory_updates_per_tick",
	--"asteroid_position_offset_to_speed_coefficient",
	--"space_platform_max_relative_speed_deviation_for_asteroid_chunks_update",

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
	{
		property = "robot_vertical_acceleration",
		multiplier_exponent = 2,
	},
	--[[
	{
		property = "vertical_acceleration",
		multiplier_exponent = 2,
	},
	--]]

	--------------------
	-- Special Speeds --
	--------------------
	{
		-- A variable affecting the speed at which trains will stop accelerating, even if other factors would allow them to go faster.
		property = "max_speed",
		restrictions = 'not (string_ends_with(object["filename"], ".ogg") or string_ends_with(object["filename"], ".wav"))',
	},
	{
		property = "space_platform_relative_speed_factor",
		multiplier_exponent = 1/2,
		restrictions = 'gtts_time_scale > 1',
	},
	{
		property = "space_platform_relative_speed_factor",
		restrictions = 'gtts_time_scale < 1',
	},
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
	"air_resistance", -- Percent of train speed lost each tick.
	"asteroid_collector_navmesh_refresh_tick_interval",
	"ejected_item_lifetime",
	"growth_ticks",
	"launch_wait_time",
	"opened_duration",
	"robot_opened_duration",
	"rocket_rising_delay",
	"space_platform_dump_cooldown",
	"space_platform_manual_dump_cooldown",
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
	"reload_time",
	"spawning_cooldown",
	"ticks_per_scan",
	"ticks_to_keep_aiming_direction",
	"ticks_to_keep_gun",
	"ticks_to_stay_in_combat",
	"time_before_shading_off",
	"time_to_capture",
	"time_to_live",
	"time_to_show_full_health_bar",
	"trigger_interval",
	"turn_after_shooting_cooldown",
	"turret_return_timeout",
	--"time_to_live_deviation",

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
	"maximum_lifetime",
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
	"time_before_start",
	--"spread_delay_deviation",
	--"time_before_start_deviation",

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
	"flying_text_ttl",
	"ground_patch_fade_in_delay",
	"ground_patch_fade_out_duration",
	"ground_patch_fade_out_start",
	"landing_squash_immunity",
	"overlay_start_delay",
	"repeat_delay",
	"respawn_time",
	"structure_animation_movement_cooldown",
	"ticks_between_player_effects",
	"time_before_removed",
	"time_to_damage",
	"train_inactivity_wait_condition_default",
	"train_temporary_stop_wait_time",
	"train_time_wait_condition_default",
	--"within",

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
		restrictions = 'gtts_time_scale < 1',
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
	"arm_energy_usage",
	"arm_slow_energy_usage",
	"crane_energy_usage",
	"energy_consumption",
	"energy_input",
	"energy_per_tick",
	"energy_usage",
	"energy_usage_per_tick",
	"idle_energy_usage", -- (?)
	"lamp_energy_usage",
	"movement_energy_consumption",
	"passive_energy_usage",
	"power_input",

	-----------------------
	-- Energy Production --
	-----------------------
	"energy",
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
	"max_power_output",
	"power",

	-------------------
	-- Miscellaneous --
	-------------------
	"heating_energy",
	"minimum_energy_produced",

	--------------------
	-- Special Energy --
	--------------------
	{
		-- Doubly scale the consumption of reactors to account for the higher specific_heat below.
		property = "consumption",
		multiplier_exponent = 2.2,
		restrictions = 'gtts_time_scale > 1 and root_type == "reactor"',
	},
	"consumption", -- Add again with no restrictions to get all other cases.
}

prototype_power_rates_recursive = {
	---------------------
	-- Energy Transfer --
	---------------------
	"drain",
	"input_flow_limit",
	"output_flow_limit",
	"specific_heat",

	--------------------
	-- Special Energy --
	--------------------
	{
		-- Double scale the max_transfer of heat to account for the higher specific_heat and fuel consumption of reactors.
		property = "max_transfer",
		multiplier_exponent = 2,
		restrictions = 'gtts_time_scale > 1',
	},
	"max_transfer", -- Add again with no restrictions to get all other cases.
}

-- Mostly these properties are here because they relate to smoke which can be generated
-- at a great many different layers in the prototype tree.
--
-- Entries with a * indicate tables of values, such as those for emissions.
prototype_speeds_recursive = {
	--------------------------------------
	-- Animation / Visualization Speeds --
	--------------------------------------
	"attacking_animation_speed",
	"back_to_walk_animation_speed",
	"cooldown_animation_speed",
	"frame_main_scanner_movement_speed",
	"prepared_animation_speed",
	"warmup_animation_speed",
	--"acceleration_x",
	--"acceleration_y",
	--"acceleration_z",
	--"max_advance",
	--"speed_x",
	--"speed_y",
	--"speed_z",

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
	"lead_target_for_projectile_speed",
	"lightnings_per_chunk_per_tick",
	"minimal_change_per_tick",
	"speed_from_center",
	"starting_speed",
	--"frame_speed_deviation",
	--"gravity", -- (?)
	--"initial_vertical_speed_deviation",
	--"smoke_cycles_per_tick",
	--"speed_from_center_deviation",
	--"starting_frame_speed",
	--"vertical_speed",
	--"vertical_speed_deviation",

	--------------------
	-- Special Speeds --
	--------------------
	{
		property = "absolute",
		restrictions = 'path_contains("absorptions_per_second")',
	},
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
		property = "effectivity",
		multiplier_exponent = 1.2,
		restrictions = 'gtts_time_scale > 1 and root_type == "reactor"',
	},
	{
		property = "effectivity",
		restrictions = 'gtts_time_scale > 1 and (path_contains("min_performance") or path_contains("max_performance"))',
	},
	{
		property = "frequency",
		restrictions = 'path_contains("smoke") or path_contains("smoke_sources")',
	},
	--[[
	{
		property = "probability",
		restrictions = 'path_contains("asteroid_spawn_definitions")',
	},
	--]]
	{
		property = "proportional",
		restrictions = 'path_contains("absorptions_per_second")',
	},
	{
		-- Many prototypes have a speed for movement speed, operating speed, etc.
		property = "speed",
		-- Asteroids seem to be too fast with the other space platform and asteroid related changes, so do not adjust the speed here.
		-- Also do not adjust sound related speed values because it does not sound correct.
		restrictions = 'not (path_contains("asteroid_spawn_definitions") or string_ends_with(object["filename"], ".ogg") or string_ends_with(object["filename"], ".wav"))',
	},
	{
		property = "starting_vertical_speed",
		multiplier_exponent = 1/2,
	},
}

prototype_durations_recursive = {
	-----------------------------------------
	-- Planet / Space Transition Durations --
	-----------------------------------------
	"draw_switch_tick",
	"end_time",
	"flight_duration", -- (?)
	"impostor_start_tick", -- (?)
	"intermezzo_max_duration",
	"intermezzo_min_duration",
	"platform_to_planet_duration_a", -- (?)
	"platform_to_planet_duration_b", -- (?)
	"platform_to_planet_hatch_open", -- (?)
	"rocket_separation_end_tick", -- (?)
	"rocket_separation_tick", -- (?)
	"solo_duration", -- (?)
	"start_time",
	"timestamp",
	--"frame",

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
	"demolisher_cloud_duration", -- (?)
	"demolisher_expanding_cloud_interval", -- (?)
	"fissure_eruption_ticks", -- (?)
	"fissure_explosion_damage_delay_ticks", -- (?)
	"fissure_explosion_particles_delay_ticks", -- (?)
	"initial_time_cooldown",
	"lead_target_for_projectile_delay",
	"movement_slow_down_cooldown",
	"slow_seconds", -- (?)
	"time_cooldown",
	"timeout",
	"warmup",
	--"fissure_explosion_delay_ticks", -- (?)

	---------------------
	-- Sound Durations --
	---------------------
	"average_pause_seconds",
	"delay_mean_seconds",
	"delay_variance_seconds",
	"fade_in_ticks",
	"fade_out_ticks",
	"fade_ticks", -- Sound related.
	"music_transition_fade_in_ticks", -- (?)
	"music_transition_fade_out_ticks", -- (?)
	"music_transition_pause_ticks", -- (?)
	--"length_seconds",
	--"start_pause",
	--"end_pause",
	--"pause_between_repetitions",
	--"pause_between_samples",

	-------------------------
	-- Animation Durations --
	-------------------------
	"ease_in_duration",
	"ease_out_duration",
	"fade_in_progress_duration",
	"fade_out_progress_duration",
	"shift_animation_transition_duration",
	"shift_animation_waypoint_stop_duration",
	"spread_progress_duration",

	-----------------------------
	-- Miscellaneous Durations --
	-----------------------------
	"cooldown",
	"delay",
	"duration",
	"explosion_visualization_duration",
	"ticks",
	--"distance_cooldown",
	--"initial_distance_cooldown",
	--"movement_slow_down_factor",
	--"scorch_mark_fade_in_frames",
	--"scorch_mark_fade_out_duration",
	--"scorch_mark_lifetime",
	--"starting_frame",
	--"starting_frame_deviation",
	--"starting_vertical_speed_deviation",

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
	{
		property = "special_action_tick",
		offset = -1, -- Set an offset value to prevent a slight flicker at high frame rates.
		restrictions = 'root_type == "procession" and root_object["name"] == "planet-to-platform-a"',
	},
	"special_action_tick", -- Add again with no restrictions to get all other cases.
	{
		property = "vertical_speed_slowdown",
		restrictions = 'gtts_time_scale > 1',
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
	["burner"] = {
		properties = {
			["effectivity"] = 1,
		},
		restrictions = 'object["type"] == "burner"',
	},
	["capsule_action"] = {
		properties = {
			["timeout"] = 3600,
		},
		restrictions = 'object["type"] == "destroy-cliffs"',
	},
	["energy_source"] = {
		properties = {
			["effectivity"] = 1,
		},
		restrictions = 'object["type"] == "burner"',
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
		{
			properties = {
				["animation_speed"] = 1,
			},
			restrictions = 'object["frame_count"] or object["stripes"] or object["slice"] or object["run_mode"] or object["max_advance"] or object["frame_sequence"]',
		},
		{
			properties = {
				["frame_speed"] = 1,
			},
			restrictions = 'object["type"] == "create-particle"',
		},
	},
}

-- Max clamp values for properties.
-- Keys can be just the property_name, root_type.property_name, or object.property_name. The latter have precedence.
prototype_values_clamp_high = {
	["explosion.fade_out_duration"] = uint8.max,
	["fire.fade_out_duration"] = uint32.max, -- Shared name with different cap, so defined by type.
	damage_interval = uint32.max,
	duration_in_ticks = uint32.max,
	ease_out_duration = uint8.max,
	flicker_interval = uint8.max,
	launch_wait_time = uint8.max - 1, -- Need to subtract 1 because otherwise rockets will not launch at high frame rates.
	life_time = uint16.max,
	maximum_lifetime = uint32.max,
	movement_slow_down_factor = 1,
	particle_fade_out_duration = uint16.max,
	spoil_ticks = uint32.max,
	time_before_removed = uint32.max,
	time_to_live = uint32.max,
	vertical_acceleration = 0.01,
	vertical_speed_slowdown = 1,

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
	["particle-source.time_to_live"] = 3.48,
	capture_speed = 0.001,
	duration = 1,
	duration_in_ticks = 1,
	flying_text_ttl = 1,
	vertical_acceleration = -0.01,

	------------------------
	-- Special Low Clamps --
	------------------------
	["optimized-particle.life_time"] = {
		{
			-- Optimized particle life time cannot be equal to 1, per the API documentation.
			-- Since this is an unsigned integer, just set the minimum to 2 if the original life time isn't 0.
			limit = 2,
			restrictions = 'object["life_time"] ~= 0',
		},
	},
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
