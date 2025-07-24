-- Return data for use by the event handler
---@type event_handler
local mod_commands = {}

-- Debug command to print the time scale history to the game console
local function debug_print_history()
    game.print(serpent.block(storage.time_scale_history))
end

-- Adds all the custom commands to the game
local function add_commands()
    commands.add_command("gtts-debug-print-history", "- Print the internal time scale history table, for debugging purposes.", debug_print_history)
end

-- Add the custom command addition function to the return data
mod_commands.add_commands = add_commands

-- Return the data table
return mod_commands
