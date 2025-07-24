-- Global config for the mod
require("config")

-- Factorio lualib event handler
local handler = require("__core__.lualib.event_handler")
handler.add_libraries({
    require("scripts.map-adjuster"),
    require("scripts.compatibility"),
    require("scripts.commands"),
})
