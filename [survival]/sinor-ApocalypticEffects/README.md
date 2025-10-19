# sinor-ApocalypticEffects
- Enhance your server with immersive post-apocalyptic effects to create a more dynamic and atmospheric world.

## Features

- **Earthquake:** Trigger earthquakes with a timer for dramatic environmental impact.
- **Disable Ambient:** Remove all ambient sounds from the game world for a desolate atmosphere.
- **Extreme Fog:** Activate thick fog by changing the time or weather, reducing visibility and adding tension.
- **Sand Storm:** Enable persistent sand storms or trigger them with a timer for harsh conditions.
- **Ash Locations:** Apply ash effects to specific areas, simulating fallout or volcanic activity.
- **Smoke Locations:** Fill areas with lingering smoke from old fires or gas leaks, creating a sense of decay.
- **Fire Locations:** Place permanent fires in the world to represent ongoing destruction.

## Getting Started

1. Download and install the resource.
2. Configure effects and triggers in the settings file.
3. Customize locations and intensity to fit your server.

## Config

```lua
Config = {}

Config.EffectRadius = 1000 -- distance for effects to appear
Config.DisableAmbient = true -- this will Disable all Ambient sounds like police siren and music and other ones on the map
-- extrem Fog related
Config.Fog = {
    Enabled = true,    -- Enable/Disable the feature by default
    FogCommand = 'togglefog', -- Enable/Disable in game
    Hours = {11, 14}, -- Hours that the fog will start and end "dont use other hours they dont work"
    WeatherResource = 'qb-weathersync', -- resource file name most weather resources use setweather export
    StartWeather = 'NEUTRAL', -- this is the extrem fog weather and it start fog Hours
    EndWeather = 'CLEAR', -- the weather after the fog end
    TransitionTime = 15.0, -- Transition from StartWeather to EndWeather or the other way
    UpdateInterval = 10000 -- keep high
}
-- SandStorm
Config.SandStorm = {
    Enabled = true,                -- master toggle
    AlwaysOn = false,              -- always on
    RandomToggle = true,           -- on/off base on "RandomInterval"
    RandomInterval = 60,           -- 60 min if RandomToggle it true
    EffectDuration = 20,           -- 20 min "it stay on 20m every 60m"
    SandStormScale = 200.0 
}
Config.SandStormLocations = {
    vector3(1931.86, 2460.09, 54.12),
    vector3(2259.42, 2790.52, 44.08),
    vector3(2664.44, 3167.03, 54.87),
    vector3(2920.46, 3790.75, 52.89),
    vector3(2789.24, 4415.88, 49.56),
    vector3(2531.82, 4169.79, 42.61),
    vector3(2375.08, 3832.1, 40.26),
    vector3(2043.31, 3661.85, 37.28),
    vector3(1827.72, 3310.41, 44.42),
    vector3(1295.13, 3328.28, 40.76),
    vector3(853.02, 3072.73, 43.01),
    vector3(434.29, 3587.49, 40.35),
    vector3(1056.98, 3623.36, 33.5),
    vector3(1709.38, 3789.51, 35.29),
    vector3(1877.59, 2952.92, 45.24),
    vector3(1499.59, 2843.3, 54.25),
    vector3(694.83, 2706.72, 39.93),
    vector3(1183.04, 2681.9, 37.38),
    vector3(1133.39, 2685.46, 37.86)
}
-- earth quake
Config.earthquakeInterval = 60 -- one houre
Config.earthquakeintensity = { min = 0.1, step = 0.5, max = 5.0 }
-- ash
Config.Ashscale = 5.0  
Config.AshLocations = { -- this locations will do ash like effect
    vector3(1743.23, 3752.16, 33.32),
    vector3(1441.13, 3603.24, 34.92),
    vector3(2380.01, 3094.55, 51.27),
    vector3(1689.76, 2591.66, 58.08),
    vector3(94.69, -989.64, 40.17),
    vector3(406.88, -979.74, 31.14),
    vector3(-484.79, -936.84, 30.17)
}
-- smoke
Config.Smokescale = 5.0 -- smoke effect scale
Config.SmokeLocations = { -- smoke locations that will show on a distance
    vector3(2738.21, 3476.66, 73.7),
    vector3(2926.72, 3383.6, 85.7),
    vector3(116.19, -771.05, 113.98),
    vector3(6.76, -935.24, 124.07),
    vector3(-145.53, -1110.39, 42.17),
    vector3(148.22, -1358.05, 39.3),
    vector3(349.56, -1633.22, 98.48),
    vector3(251.88, -813.87, 75.79),
    vector3(265.76, -1070.65, 83.81),
    vector3(878.22, -1825.37, 80.84),
    vector3(-3.23, -2227.91, 32.39),
    vector3(-847.14, -2146.33, 101.7),
    vector3(-982.03, -2635.34, 89.48),
    vector3(-944.62, -2930.41, 53.86),
    vector3(-2024.54, -1039.52, 5.25),
    vector3(-1825.54, -353.46, 93.84),
    vector3(-1880.81, -309.58, 92.65),
    vector3(-778.27, 329.83, 238.38),
    vector3(472.89, -99.43, 123.42),
    vector3(678.99, 134.58, 78.87),
    vector3(910.18, 52.55, 111.27),
    vector3(921.01, -947.68, 62.3),
    vector3(1676.5, -1702.93, 122.39),
    vector3(1250.38, -2568.49, 42.03),
    vector3(1019.38, -2882.65, 47.68),
    vector3(1240.48, -2977.82, 9.16)

}
-- fire
Config.Firescale = 4.0 -- fire effect scale
Config.FireLocations = { -- fire locations "they will be on all the time"
    vector3(300.24, -591.25, 60.67),
    vector3(433.33, -986.07, 43.77),
    vector3(76.15, -1013.64, 79.85),
    vector3(-63.99, -542.4, 32.87),
    vector3(265.76, -1070.65, 83.81),
    vector3(871.01, -1928.24, 95.69),
    vector3(-307.84, -2197.95, 25.37),
    vector3(-941.2, -3049.42, 20.76),
    vector3(-2024.54, -1039.52, 5.25),
    vector3(-1857.94, -347.06, 49.9),
    vector3(87.73, 288.6, 115.57),
    vector3(331.31, -70.44, 72.5),
    vector3(739.12, 135.5, 80.74),
    vector3(910.18, 52.55, 111.27),
    vector3(1676.5, -1702.93, 122.39),
    vector3(1736.63, -1458.43, 119.92),
    vector3(1720.53, -1515.27, 120.46),
    vector3(1250.38, -2568.49, 42.03),
    vector3(1208.29, -3251.01, 7.17),
    vector3(103.99, -931.97, 86.93),
    vector3(184.11, -1101.83, 49.44),
    vector3(355.19, -827.46, 72.03)

}

```
## Support :

- Join Discord for more updates and suggestion related to our resources.

