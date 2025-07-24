-- Create the compatibility mod-data prototype
local mod_data = {}
mod_data.type = "mod-data"
mod_data.name = "gtts-tick-rate"
mod_data.data_type = "gtts.tick_rate"
mod_data.data = { tick_rate = gtts_safe_mode and 60 or gtts_tick_rate }


-- Create the compatibility event prototype
--local mod_event = {}
--mod_event.type = "custom-event"
--mod_event.name = "gtts-on-tick-rate-changed"


-- Add the new prototypes to the prototype data
data:extend({
    mod_data,
    --mod_event,
})
