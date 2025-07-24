# GTTS 1.7.7 2024-10-27

The Mod should be updated for Space Age now.

This mod changes all available prototype speeds and durations to effectively change the duration of one game tick. This allows players to speed up slow factories by increasing the amount of time the game has to calculate the tick without having to delay the game, or allows the game to be played at higher framerates for players that have high refresh rate monitors.

# Usage and limitations

Due to item locations on belts being quantized to 1/256 of a tile, accurate item movement on belts requires a UPS value of 480/x. Suggested UPS for belt accuracy are:

480, 240, 160, 120, 96, 80, 60, 48, 40, 32, 30, 24, 20, 19.2, 16, 15 and 12

The mod is somewhat limited in what it can change, so references to speeds or rates will be incorrect based on the ratio between the target UPS and the base 60 UPS. If, for example, a boiler lists its energy consumption as 7.2 MW, it effectively means that it will use 7.2 MJ in 60 ticks. At 30 UPS this will take 2 seconds in wall time, which matches with the normal rate of 3.6 MW at 60 UPS. Because all production and consumption rates are adjusted equally, everything balances out to work at the original Factorio ratios. Unfortunately, train schedules are going to be incorrect as well, as they are again based on 1 second being equal to 60 ticks. 

Some of the changes this mod makes are saved in the game file. By default, this is limited to only the game speed, so a simple "/c game.speed = 1" command on the console can return the game speed of a modded save to the original 60 UPS. However, you can also use the "Reset Game Speed" map specific option to immediately reset the game speed to 60 UPS, as well as disable any other save game stored adjustments like hand crafting speed before saving the game so that the mod can be disabled with minimal disruption.

In safe mode, no runtime events are added, meaning the mod can make no changes beyond those made to prototypes when factorio loads. The game speed must be adjusted manually, along with any hand crafting speeds.

Useful console commands

/c game.speed = {target-ups} / 60
/c game.player.character.character_crafting_speed_modifier = 60 / {target-ups} - 1

# Mod compatibility

Due to the nature of this mod, it needs to load as late as possible in order to adjust the prototypes of other mods. The mod has an existing list of optional dependencies to help with this, but if you notice a mod incorrectly loading after this mod, feel free to open a discussion post about it and it can hopefully be corrected for the next version if needed and possible.

As long as this mod loads after all other mods that are dependent on speed or time, then their prototypes will be automatically adjusted. Unfortunately, the mod is unable to make runtime adjustments to other mods unless they provide explicit compatibility in some way. To help with this, this mod creates a "mod-data" prototype entry and has a basic remote interface that other mods can use.

## Mod data and remote interface calls (For mod developers)

If you want to get the mod's current tick rate in the control stage, you can use something like this:

```lua
local function get_tick_rate()
    local mod_data = prototypes.mod_data["gtts-tick-rate"]
    return mod_data and mod_data.data.tick_rate or 60
end
```

This will return the appropriate ticks per second value based on the mod settings, or 60 if the mod is not active. It is recommended to do this instead of accessing the setting directly as the mod data prototype will respect other mod settings, such as the safe mode setting.

If you want to check if the remote interface is active, you can use something like this:

```lua
local function is_gtts_active()
    return (remote and remote.interfaces["GTTS"] ~= nil) or false
end
```

If you want to get the real time tick equivalent of any arbitrary game tick, you can use something like this:

```lua
---@param tick MapTick? Any arbitrary game tick. Defaults to current game tick if not specified.
---@return {tick:MapTick, tick_rate:number, effective_tick:number}?
local function get_effective_tick(tick)
    if (remote and remote.interfaces["GTTS"] and remote.interfaces["GTTS"]["get_tick_data"]) then
        return remote.call("GTTS", "get_tick_data", tick)
    end
end
```

This will return a table with the following entries:

* `tick`            - `MapTick`. The game tick that was converted.
* `tick_rate`       - `number`. The tick rate that the tick above was running at.
* `effective_tick`  - `number`. The value that the tick above would have been if the tick rate was 60 over the entire game.

The `effective_tick` value can then be used for applications such as getting an accurate timestamp for the player.

If the mod data or remote interface are missing anything necessary to add support to your mod, feel free to open a discussion post and it can be discussed.

# Contact

Zanthra (zanthra+factoriogtts@gmail.com)

Factorio Mod Portal: https://mods.factorio.com/mods/Zanthra/GTTS  
Factorio Forums: https://forums.factorio.com/viewtopic.php?f=144&t=50281

# Special thanks

Thanks to: oorzkws for updates to clamping code.
