Config = {}
-- prints for both server and client
Config.PrintMain = false -- print the main zombies related code
Config.PrintSpecial = false -- print Special zombies related code
Config.PrintNpc = false -- print the npc spawner related code
Config.PrintAnimals = false -- print Boss animals related code
-- Sound Related
Config.SoundSystem = "xsound" -- "sounity" or "xsound"
Config.ZombieRangeSounds = {"range01", "range02", "range03", "range04","range05"} 
Config.ZombieAttackSounds = {"attack01"} 
Config.ZombieGroupSounds = {"LargHorde01", "LargHorde02"} --this one is sound in the background for Hords 
Config.soundRange = 15.0 --zombie Range
Config.soundVolume = 0.1 -- sound Volume
Config.GroupSoundThreshold = 15 -- haw many zombies to play "ZombieGroupSounds"
Config.GroupSoundCooldown = 10000 --Cooldown
Config.SoundDuration = 5000  -- How long each sound plays
Config.MaxActiveZombieSounds = 2  -- Limit the number of zombie sounds in Distance
-- Zombies Related
Config.ZombiesCleanUp = 2 -- time it take to clean dead zombies "in minutes"
Config.IgnoreDeadPlayer = true -- Ignore if player is dead "fully bledout"
Config.ZombiesFallCount = 3 -- falling to the ground when surrounded by 3 zombies
Config.FallChance = 10 -- 10% chance if surrounded by "ZombiesFallCount"
Config.fallCooldown = 1 -- in minutes 
Config.ZombiesDistanceAttack = 1.5 -- Normal Zombies Models Attack Distance
Config.RunningDistanceAttack = 1.0 -- Runner Zombies Models Attack Distance
Config.Headshots = true -- Enable or disable headshot insta-kills for zombies
Config.SafeZoneDensity = false -- Enable or disable zombies spawning in safe zones
Config.PlayerDamage = 3 -- damage taken from zombie hit
Config.allowClimbingLadders = false  -- Set to false if you want to prevent zombies from climbing ladders
Config.AttackCooldown = 500 --Zombies Attack animations Cooldown
Config.DeleteDeadZombies = false  -- Set to true to delete zombies after they die
Config.PlayerTalkingRange = 5.0 -- Adjust here 0.0 = false "player using proximity chat" works With `pma-voice`
Config.ZombiesHealth = 150 -- Global Zombies health
-- vehicle related
Config.RemoveOutOfVehicle = true  -- Set to true to allow zombies to pull players out of vehicles, false to disable
Config.VehicleDamage = true  -- Set to true to allow zombies to damage vehicle engine and glass when players are inside
Config.VehicleDamageAmount = 5  -- Amount of damage zombies inflict on vehicles each attack
-- Distance Related
Config.DistanceTargets = { -- Distance for attracting zombies
    Shooting = 100.0,--player Shooting
    InVehicle = 70.0,--player in Vehicle
    Running = 50.0,--player Running
    Melee = 30.0, -- melee attack
    Standing = 5.0,--player standing 
    Crouching = 3.0,--player Crouching 
    closestPlayer = 20.0, --closest player as the target for the zombie
}
-- Safe Zones 
Config.safezone_translate = {
    title = 'Safe Zone',
    enter = 'You are in a SafeZone',
    leave = 'You are no longer in a SafeZone'
}
Config.allowsafezoneweapons = true -- Allow/disable weapons in safe zones
Config.SafeZones = {
    {coords = vector3(-581.78, -166.96, 39.74), radius = 60.0}, -- alta street
    {coords = vector3(-413.83, 1173.76, 337.04), radius = 120.0}, -- galileo observatory
    {coords = vector3(360.76, -1590.5, 36.95), radius = 90.0}, -- davis avenue
    --{coords = vector3(2048.74, 3418.85, 49.0), radius = 120.0}, -- sandy shores
    {coords = vector3(-551.52, 5325.73, 75.27), radius = 120.0}, -- wood factory 
    --{coords = vector3(2632.86, 2933.43, 48.71), radius = 70.0}, -- train station
    {coords = vector3(465.06, -787.55, 48.32), radius = 100.0}, -- china town
    {coords = vector3(199.13, 2771.14, 50.59), radius = 50.0}, -- route 68 
    --{coords = vector3(-398.75, -2245.06, 13.99), radius = 90.0} -- autopia parkway
    -- Add more as needed
}
-- Excluded Peds
Config.ExcludedPeds = { -- Peds that can spawn normally in zombies zones if used
    "mp_f_freemode_01",
    "mp_m_freemode_01",
    "s_m_y_marine_03",
    "s_f_y_scrubs_01",
    "a_m_o_soucent_03",
    "a_m_y_dhill_01",
    "a_m_y_hippy_01",
    "cs_beverly",
    "ig_hunter"
    -- Add more models as needed
}
-- Zombie Models "the only peds that are zombies"
Config.ZombieModels = {
    "a_f_y_juggalo_01",
    "a_m_m_beach_01",
    "a_m_m_eastsa_02",
    "a_m_m_farmer_01",
    "a_m_m_fatlatin_01",
    "a_m_m_hillbilly_01",
    "a_m_m_malibu_01",
    "a_m_m_mexlabor_01",
    "a_m_m_og_boss_01",
    "a_m_m_polynesian_01",
    "a_m_m_rurmeth_01",
    "a_m_m_salton_02",
    "a_m_m_skater_01",
    "a_m_m_skidrow_01",
    "a_m_m_soucent_04",
    "a_m_m_tennis_01",
    "a_m_o_acult_02",
    "a_m_y_genstreet_01",
    "a_m_y_genstreet_02",
    "a_m_y_methhead_01",
    "a_m_y_salton_01",
    "a_m_y_stlat_01",
    "s_m_y_cop_01",
    "s_m_y_prismuscl_01"
}
-- Zombies spawner settings
Config.SpawnerOptions = {
    MinSpawnDistance = 50,
    MaxSpawnDistance = 150,
    DespawnDistance = 300,
    SpawnZombieLimit = 50,-- Maximum zombies per player "keep lew they will keep spawning if dead or deleted"
    ZombieModels = {
        "a_m_m_beach_01",
        "a_m_m_eastsa_02",
        "a_m_m_farmer_01",
        "a_m_m_fatlatin_01",
        "a_m_m_hillbilly_01",
        "a_m_m_malibu_01",
        "a_m_m_mexlabor_01",
        "a_m_m_og_boss_01",
        "a_m_m_polynesian_01",
        "a_m_m_salton_02",
        "a_m_m_skater_01",
        "a_m_m_skidrow_01",
        "a_m_m_soucent_04",
        "a_m_m_tennis_01",
        "a_m_o_acult_02",
        "a_m_y_genstreet_01",
        "a_m_y_genstreet_02",
        "a_m_y_methhead_01",
        "a_m_y_salton_01",
        "a_m_y_stlat_01",
        "s_m_y_cop_01"
        -- Add more models as needed
    },
    ZombieWalks = {
        "anim@ingame@move_m@zombie@core",
        "move_m@drunk@moderatedrunk",
        "move_m@drunk@a",
        "anim_group_move_ballistic"
        -- Add more models as needed
    },
}
-- zones related
Config.use_zones = false

Config.ZombiesZones = {
    ["paleto_zombies"] = {
        Debug = false,
        Zones = {{
            minZ = -100.0,
            maxZ = 1200.0,
            Coords = {
                vector2(-738.2, 7236.5),
                vector2(-88.9, 7144.7),
                vector2(663.4, 6565.6),
                vector2(-504.5, 5850.1),
                vector2(-1272.3, 6200.2),
            }
        }},
    },

    ["grapeseed_zombies"] = {
        Debug = false,
        Zones = {{
            minZ = -100.0,
            maxZ = 1200.0,
            Coords = {
                vector2(1510.6, 5359.2),
                vector2(2675.4, 5184.0),
                vector2(2806.1, 4507.7),
                vector2(1668.7, 4420.9),
            }
        }},
    },

    ["sandy_zombies"] = {
        Debug = false,
        Zones = {{
            minZ = -100.0,
            maxZ = 1200.0,
            Coords = {
                vector2(1176.9, 3782.3),
                vector2(2438.5, 4062.9),
                vector2(2672.6, 3369.6),
                vector2(1637.1, 3232.1),
            }
        }},
    },

    ["harmony_zombies"] = {
        Debug = false,
        Zones = {{
            minZ = -100.0,
            maxZ = 1200.0,
            Coords = {
                vector2(-500.0, 2835.0),
                vector2(160.0, 3000.0),
                vector2(620.0, 2550.0),
                vector2(-550.0, 2300.0),
            }
        }},
    },

    ["los_santos_norte"] = {
        Debug = false,
        Zones = {{
            minZ = -100.0,
            maxZ = 1200.0,
            Coords = {
                vector2(-1300.0, 3600.0),
                vector2(-300.0, 3000.0),
                vector2(800.0, 3000.0),
                vector2(200.0, 4000.0),
                vector2(-1300.0, 4000.0),
            }
        }},
    },

    ["los_santos_centro"] = {
        Debug = false,
        Zones = {{
            minZ = -100.0,
            maxZ = 1200.0,
            Coords = {
                vector2(-1550.0, -200.0),
                vector2(-500.0, -200.0),
                vector2(600.0, 600.0),
                vector2(-300.0, 900.0),
                vector2(-1600.0, 400.0),
            }
        }},
    },

    ["los_santos_sul"] = {
        Debug = false,
        Zones = {{
            minZ = -100.0,
            maxZ = 1200.0,
            Coords = {
                vector2(-1700.0, -700.0),
                vector2(1300.0, -700.0),
                vector2(1300.0, -3000.0),
                vector2(-1700.0, -3000.0),
            }
        }},
    },

    ["blaine_rural"] = {
        Debug = false,
        Zones = {{
            minZ = -100.0,
            maxZ = 1200.0,
            Coords = {
                vector2(-2000.0, 4400.0),
                vector2(-500.0, 4400.0),
                vector2(-500.0, 5200.0),
                vector2(-2000.0, 5200.0),
            }
        }},
    },
}

-- nest related
Config.NestSystem = {
    nesteffect_Dict = "scr_ch_finale",
    nesteffect_name = "scr_ch_finale_poison_gas",
    nesteffect_scale = 8.0,
    distance = 200, -- at this distance the nest will trigger spawning
    pointsLimit = 25, -- Max zombies per nest 
    DispawnDistance = 200, -- beyond this distance from nest Zombies will despawn
    nest_points = {
        {coords = vector3(1158.99, 3116.99, 40.35), models = {"a_f_y_juggalo_01"}}, -- example fire zombies only in the nest
        {coords = vector3(507.34, 2988.48, 40.82), models = {"a_m_m_farmer_01"}}, -- gas zombies
        {coords = vector3(985.21, 2298.32, 49.7), models = {"a_m_m_rurmeth_01"}}, -- poison zombies
        {coords = vector3(985.35, 251.67, 80.57), models = {"a_m_m_rurmeth_01"}}, -- poison zombies   
	   -- Add more nests as needed
    }
}
-- animals related
Config.animal_settings = {
    MinAnimals = 2,
    MaxAnimals = 5,
    SpawnDistance = { min = 70, max = 120 },
    DespawnDistance = 250, -- dispawn distance
    SafeZoneCheck = false,-- if true animals dont spawn in safe zone
    onlyzones = true, -- If true, animals spawn only in defined zones
    AnimalZones = {"CMSW", "MTCHIL", "MTGORDO", "MTJOSE", "PALFOR", "PALHIGH", "SANCHIA", "TONGVAH"},--to find more zones search int GET_ZONE_FROM_NAME_ID
    AnimalModels = {
        "a_c_coyote",
        "a_c_deer",
        "a_c_pig",
        "a_c_boar",
        "a_c_rabbit",
        "a_c_mtlion",
        "a_c_cow",
        "a_c_hen",
        "a_c_rooster"
    }
}
-- Special Zombies
Config.SpecialZombies = {
    -- full effects example 
    -- you can add zombies with all effects no problem
    -- {
    --     model = "ped_model_here",
    --     IsRunner = true, -- if zombies is runner 
    --     IsOnFire = true, -- if on fire
    --     IsGas = true, -- if gas do the settings under
    --     GasSettings = { gasRange = 5.0, healthDamage = 1, drunkEffect = false },
    --     IsStronger = true, if stronger add the hp under
    --     StrongerSettings = { hp = 700 },
    --     IsElectric = true,-- if electric do the settings under
    --     ElectricSettings = { effectRange = 5.0, damage = 5, shockEffect = true },
    --     IsProp = true,-- if prop do the settings under 
    --     PropSettings = { propModel = "prop_gascyl_01a", offset = { x = 0.07, y = -0.07, z = -0.03} }-- am using "prop_gascyl_01a" so it do Explosion
    --     IsPoison = true, --if poison use the settings under
    --     PoisonSettings = { effectRange = 5.0, damage = 5, PoisonEffect = true }, -- change as needed
    -- },
    -- stonger zombies and prop example
    {
        model = "s_m_y_prismuscl_01",
        IsStronger = true,
        StrongerSettings = { hp = 2500 },
        IsProp = true,
        PropSettings = { propModel = "prop_gascyl_01a", offset = { x = 0.07, y = -0.07, z = -0.03} }
    },
    -- only fire zombies example
    {
        model = "a_f_y_juggalo_01",
        IsOnFire = true,
    },
    {
        model = "a_m_o_acult_02",
        IsOnFire = true,
    },
    -- runner and gas zombies example
    {
        model = "a_m_m_farmer_01",
        IsRunner = true,
        IsGas = true,
        GasSettings = { gasRange = 5.0, healthDamage = 1, drunkEffect = true },
    },
    -- runner and fire and stronger zombies example
    {
        model = "a_m_m_og_boss_01",
        IsRunner = true,
        IsOnFire = true,
        IsStronger = true,
        StrongerSettings = { hp = 400 },
    },
    -- runner and electric zombies example
    {
        model = "s_m_y_cop_01",
        IsRunner = true, 
        IsElectric = true,
        ElectricSettings = { effectRange = 5.0, damage = 5, shockEffect = true },
    },
    -- props zombies example
    {
        model = "a_m_y_genstreet_01",
        IsProp = true,
        PropSettings = { propModel = "prop_gascyl_01a", offset = { x = 0.07, y = -0.07, z = -0.03} }
    },
    -- poison zombies example
    {
        model = "a_m_m_rurmeth_01",
        IsPoison = true,
        PoisonSettings = { effectRange = 5.0, damage = 5, PoisonEffect = true },
    },
    -- Add more special zombies as needed

}
-- npc zones
Config.NpcsrespawnTime = 15 -- in minutes 
Config.npc_zones = {
    -- note : You Have to Add Only "ExcludedPeds" So Npcs Spawn Normaly
    ---- Friendly Examples ----
    {
        coords = vector3(-408.65, 1238.9, 327.51),-- this is needed so if npcs get out of zone they are deleted
        radius = 200.0, -- Zone radius
        type = "FRIENDLY", -- Friendly NPCs won't attack the player
        positions = {
            {model = "s_f_y_scrubs_01", coords = vector4(-425.85, 1110.8, 326.68, 40.2), task = "WORLD_HUMAN_STAND_MOBILE"},
            {model = "a_m_o_soucent_03", coords = vector4(-426.91, 1110.19, 326.68, 358.71), task = "WORLD_HUMAN_SMOKING"},
            {model = "a_m_y_dhill_01", coords = vector4(-431.61, 1112.2, 326.68, 301.37), task = "WORLD_HUMAN_SMOKING"},
            {model = "s_f_y_scrubs_01", coords = vector4(-404.39, 1193.38, 324.66, 114.16), task = "WORLD_HUMAN_STAND_MOBILE"},
            {model = "ig_hunter", coords = vector4(-371.55, 1259.6, 328.04, 206.35), task = "WORLD_HUMAN_SMOKING"},
            {model = "a_m_y_dhill_01", coords = vector4(-430.66, 1183.96, 324.8, 294.94), task = "WORLD_HUMAN_SMOKING"},
            {model = "a_m_y_dhill_01", coords = vector4(-405.23, 1163.86, 324.92, 347.21), task = "WORLD_HUMAN_SIT_UPS"},
            {model = "ig_hunter", coords = vector4(-405.79, 1161.31, 324.92, 153.36), task = "WORLD_HUMAN_SIT_UPS"},
            {model = "s_m_y_marine_03", coords = vector4(-408.75, 1163.01, 324.91, 272.33), task = "WORLD_HUMAN_PUSH_UPS"},
            {model = "ig_hunter", coords = vector4(-430.44, 1134.22, 324.9, 91.34), task = "WORLD_HUMAN_GARDENER_LEAF_BLOWER"},
            {model = "a_m_y_dhill_01", coords = vector4(-415.66, 1129.38, 324.9, 253.65), task = "WORLD_HUMAN_GARDENER_PLANT"}
        }
    },
    ---- unFriendly Example ----
    {
        coords = vector3(-468.81, 5996.75, 31.28),
        radius = 90.0, -- Zone radius
        type = "UNFRIENDLY", -- Unfriendly NPCs will attack the player on sight
        positions = {
            {model = "s_m_y_marine_03", coords = vector4(-450.42, 6013.41, 40.48, 320.23), task = "WORLD_HUMAN_GUARD_PATROL"},
            {model = "s_m_y_marine_03", coords = vector4(-439.76, 6002.22, 40.44, 232.8), task = "WORLD_HUMAN_GUARD_PATROL"},
            {model = "s_m_y_marine_03", coords = vector4(-430.93, 5994.51, 35.31, 259.54), task = "WORLD_HUMAN_GUARD_PATROL"},
            {model = "s_m_y_marine_03", coords = vector4(-444.57, 5987.76, 35.31, 91.42), task = "WORLD_HUMAN_GUARD_PATROL"},
            {model = "s_m_y_marine_03", coords = vector4(-476.97, 6027.64, 31.34, 272.02), task = "WORLD_HUMAN_GUARD_PATROL"}

        },
        weapons = {"WEAPON_COMBATPISTOL"} -- Weapons for unfriendly NPCs
    }
    --- add more as needed
}
