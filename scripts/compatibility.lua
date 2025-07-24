-- Return data for use by the event handler
---@type event_handler
local compatibility = {}

-- Local reference for the scale history table in the storage data
-- This table saves an entry each time the tick rate changes
-- Each entry contains the new tick rate, the game tick when the tick rate changed, and the effective tick when the tick rate changed
---@type {tick:number, tick_rate:number, effective_tick:number}
local time_scale_history = nil

-- Local reference to the reset game speed setting
local gtts_reset_speed = settings.global["gtts-Reset-GameSpeed"] and settings.global["gtts-Reset-GameSpeed"].value == true or false


--- Calculates the effective tick rate for arbitrary start/end ticks, tick rate, and effective start tick
---@param start_tick MapTick
---@param end_tick MapTick
---@param tick_rate number
---@param effective_start_tick MapTick?
---@return number
local function calculate_effective_tick(start_tick, end_tick, tick_rate, effective_start_tick)
    effective_start_tick = effective_start_tick or 0
    local tick_change = end_tick - start_tick
    local tick_multiplier = 60 / tick_rate
    return math.floor(effective_start_tick + (tick_change * tick_multiplier))
end


-- Restores or initializes the time scale history with a base entry, if needed
-- Also calculates the effective game tick values for the entire history
---@return nil
local function initialize_storage_data()
    storage.time_scale_history = storage.time_scale_history or { { tick = 0, tick_rate = 60, effective_tick = 0 } }
    time_scale_history = storage.time_scale_history

    -- Calculate (or recalculate) the effective tick values for the entire history
    -- Ensures these values are always calculated, and allows for easily updating them if this code logic changes later
    local last_entry = nil
    for _, entry in ipairs(time_scale_history) do
        entry.effective_tick = last_entry and calculate_effective_tick(last_entry.tick, entry.tick, last_entry.tick_rate, last_entry.effective_tick) or 0
        last_entry = entry
    end
end


-- Saves the current game tick, tick rate setting, and effective game tick to the time scale history table
---@return nil
local function save_time_change()
    -- Initialize the history if it isn't yet initialized
    if not time_scale_history then
        initialize_storage_data()
    end

    -- Get the last entry in the history
    local last_entry = time_scale_history[#time_scale_history]

    -- Get the tick rate to save
    local rate_to_save = (gtts_safe_mode or gtts_reset_speed) and 60 or gtts_tick_rate

    -- If the tick rate is the same, no need to change anything so just return
    if last_entry.tick_rate == rate_to_save then
        return
    end

    -- Get the tick value to save
    local tick_to_save = game.tick

    -- If the stored tick is the same as the current tick, then update the tick rate to the current one and return
    if last_entry.tick == tick_to_save then
        last_entry.tick_rate = rate_to_save
        return
    end

    -- Calculate and save the effective tick in a new entry
    local effective_tick = calculate_effective_tick(last_entry.tick, tick_to_save, last_entry.tick_rate, last_entry.effective_tick)
    local new_entry = { tick = tick_to_save, tick_rate = rate_to_save, effective_tick = effective_tick }

    -- Save this new entry to the time scale history
    table.insert(time_scale_history, new_entry)

    -- Raise an event to signal that the tick rate changed
    --local event_data = { tick_data = { tick = tick_to_save, tick_rate = gtts_tick_rate, effective_tick = effective_tick} }
    --script.raise_event("gtts-on-tick-rate-changed", event_data)
end


-- Runs when starting a new save game or for mods that are new to an existing one
---@return nil
local function on_init()
    -- Initialize the storage data and save the current time scale if needed
    initialize_storage_data()
    save_time_change()
end


-- Runs for every mod that has been a part of the save previously, including when loading a save to connect to a running multiplayer session
---@return nil
local function on_load()
    -- Set the local reference for the storage data
    time_scale_history = storage.time_scale_history
end


-- This step runs for all mods if the save's mod configuration has changed
---@param event ConfigurationChangedData
---@return nil
local function on_configuration_changed(event)
    -- Only need to continue if this mod changed or if the startup settings changed
    if event.mod_startup_settings_changed or (event.mod_changes and event.mod_changes[gtts_mod_name]) then
        -- Ensure the storage data is initialized and save the current time scale if needed
        initialize_storage_data();
        save_time_change();
    end
end


-- Runs for every runtime setting that is changed
---@param event EventData.on_runtime_mod_setting_changed
---@return nil
local function on_runtime_mod_setting_changed(event)
    -- If the reset game speed setting was changed, save the current time scale if needed
    if event.setting == "gtts-Reset-GameSpeed" then
        gtts_reset_speed = settings.global["gtts-Reset-GameSpeed"] and settings.global["gtts-Reset-GameSpeed"].value == true or false
        save_time_change()
    end
end


-- Gets a table containing the given tick or current game tick, the tick rate for that tick, and the effective tick version of that tick
---@param tick MapTick?
---@return {tick:MapTick, tick_rate:number, effective_tick:number}?
local function get_tick_data(tick)
    -- Get the game tick for find the data for
    tick = tick or game.tick

    -- If this game tick is invalid, then return nil
    if type(tick) ~= "number" or tick < 0 then
        return nil
    end

    -- Initialize the history if it isn't yet initialized
    if not time_scale_history then
        initialize_storage_data()
    end

    -- Calculate the effective tick for the given game tick
    local tick_data = nil
    for i = #time_scale_history, 1, -1 do
        local entry = time_scale_history[i]
        if entry.tick <= tick then
            local effective_tick = calculate_effective_tick(entry.tick, tick, entry.tick_rate, entry.effective_tick)
            tick_data = { tick = tick, tick_rate = entry.tick_rate, effective_tick = effective_tick }
            break
        end
    end

    -- Return the final tick data
    return tick_data
end


-- Adds the compatibility functions to the remote interface for use by other mods
---@return nil
local function add_remote_interface()
    remote.add_interface(gtts_API_name, {
        get_tick_data = get_tick_data,
    })
end


-- Add the init, load, and changed configuration events
compatibility.on_init = on_init
compatibility.on_load = on_load
compatibility.on_configuration_changed = on_configuration_changed

-- Add the other events
compatibility.events = {
    [defines.events.on_runtime_mod_setting_changed] = on_runtime_mod_setting_changed,
}

-- Add the remote interface functions immediately, not with the event handler
-- Hopefully reduces potential issues related to mod load order when other mods try to use these functions
-- This is important as this mod should be running very late in the load order by design
add_remote_interface()


-- Return the data table
return compatibility
