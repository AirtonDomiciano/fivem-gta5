## QBCore|ESX Vehicle Craft
- Have you ever wanted the ability to craft vehicles using items you've found or created? With this resource, you can now bring that idea to life!

## Features
- Crafting Tables : Players Have to Craft Vehicles Parts ,use `Config.parts` to change the materials needed to craft the parts.
- Craft Vehicles: Players can craft vehicles using customizable, configured parts.
- Flexible Vehicle List: Easily add as many vehicles as you want in `Config.craftableVehicles`.
- Location Configuration: Use `Config.craftingProps` to spawn new props For players to intract with.
- Ownership System: The ownership of each crafted vehicle automatically belongs to the player who crafted it.

## Dependencies
- To ensure full functionality, the following dependencies are required:
# QBCore
- qb-target or ox_target
- qb-menu or ox_lib
- qb-inventory or ox_inventory "other inventories may work!"
# ESX
- ox_target
- ox_lib
- ox_inventory "other inventories may work!"

## Config
```lua
Config = {}
Config.Framework = 'QBCore' -- Options: 'QBCore', 'ESX'
Config.CoreGetCoreObject = {
    QBCore = 'qb-core', -- Default core name for QBCore
    ESX = 'es_extended' -- Default core name for ESX
}
Config.MenuSystem = "ox_lib" -- Options: 'qb-menu', 'ox_lib'
Config.TargetSystem = "qb-target" -- Options: 'qb-target', 'ox_target'
Config.progressCraftTime = 20000 -- 20s to craft
Config.progressCheckItemsTime = 3000 -- 3s to check parts 'added it for anti spam'
Config.WebhookURL = "Webhook_Here" 
-------------------------------
---------crafting Table--------
------------------------------- 
Config.craftingTableProp = "prop_tool_bench02_ld" -- Name of the crafting table prop
Config.tableLocations = {
    { coords = vector3(-392.72, 1193.67, 324.64), heading = 0.0, spawnProp = true },
    -- add as more as needed
}
Config.parts = {
    engine = {
        items = { name = "carengine", label = "Vehicle Engine" },
        materials = {iron = 120,steel = 32,rubber = 24,plastic = 32,electronicscrap = 200}
    },
    tire = {
        items = { name = "tire", label = "Tire" }, 
        materials = {rubber = 50,steel = 22,}
    },
    rim = {
        items = { name = "rim", label = "Rim" }, 
        materials = {steel = 80,plastic = 20}
    },
    battery = {
        items = { name = "battery", label = "Vehicle Battery" }, 
        materials = {copper = 12,rubber = 20,plastic = 30, electronicscrap = 82}
    },
    gear = {
        items = { name = "gear", label = "Vehicle Gear" }, 
        materials = {rubber = 12,plastic = 30,steel = 42,iron = 90}
    },
    sparkplugs = {
        items = { name = "sparkplugs", label = "Spark plugs" }, 
        materials = {rubber = 4,steel = 12,plastic = 3,electronicscrap = 11}
    },
    cycleframe = {
        items = { name = "cycleframe", label = "Cycle Frame" }, 
        materials = {steel = 120,iron = 200,metalscrap = 82,aluminum = 40,plastic = 70,glass = 30}
    },
    vehicleframe = {
        items = { name = "vehicleframe", label = "Vehicle Frame" },
        materials = {steel = 370,iron = 600,metalscrap = 220,aluminum = 340,plastic = 100,glass = 300}
    }
    -- add as more as needed
}
-------------------------------
---------crafting Vehicle------
------------------------------- 
Config.craftingProps = {
    land = {
        prop = "xs_prop_x18_wheel_balancer_01a",--xs_prop_x18_carlift
        locations = {
            { coords = vector3(2821.42, -711.23, 4.59), heading = 353.09, spawnOffset = vector3(0.0, -5.0, 1.0), spawnProp = true }
            -- add as more as needed
        }
    },
    sea = {
        prop = "xs_prop_x18_wheel_balancer_01a",
        locations = {
            { coords = vector3(2948.75, -737.64, 1.66), heading = 262.06, spawnOffset = vector3(1.0, -8.0, 1.0), spawnProp = true }
            -- add as more as needed
        }
    },
    air = {
        prop = "xs_prop_x18_wheel_balancer_01a",--prop_air_bench_02
        locations = {
            { coords = vector3(2915.38, -690.57, 5.3), heading = 352.49, spawnOffset = vector3(0.0, -7.0, 1.0), spawnProp = true }
            -- add as more as needed
        }
    }
}
Config.craftableVehicles = {
    land = {
        ["dune"] = {
            displayName = "Dune Buggy",
            image = "nui://sinor-VehicleCraft/images/dune.png",
            parts = { tire = 4, battery = 1, gear = 1, sparkplugs = 3, rim = 4, carengine = 1, vehicleframe = 1 }
        },
        ["ratloader"] = {
            displayName = "Rat Loader",
            image = "nui://sinor-VehicleCraft/images/ratloader.png",
            parts = { tire = 4, battery = 1, gear = 1, sparkplugs = 8, rim = 4, carengine = 1, vehicleframe = 2 }
        },
        ["ratbike"] = {
            displayName = "Rat bike",
            image = "nui://sinor-VehicleCraft/images/ratbike.png",
            parts = { tire = 2, battery = 1, gear = 1, sparkplugs = 2, rim = 2, carengine = 1, cycleframe = 1 }
        }
        -- add as more as needed
    },
    sea = {
        ["dinghy"] = {
            displayName = "Dinghy",
            image = "nui://sinor-VehicleCraft/images/dinghy.png",
            parts = { battery = 1, gear = 1, sparkplugs = 2 }
        }
        -- add as more as needed
    },
    air = {
        ["seasparrow"] = {
            displayName = "sea sparrow",
            image = "nui://sinor-VehicleCraft/images/seasparrow.png",
            parts = { battery = 1, gear = 1, sparkplugs = 2 }
        }
        -- add as more as needed
    }
}

```

# Installation 

## Items Installation
# QBCore:
- Go to `sinor-VehicleCraft\install\items\qb\items.lua`.
# ESX:
- Go to `sinor-VehicleCraft\install\items\esx\items.sql`.
# ox_inventory"Optional FOR ESX":
- Go to `sinor-VehicleCraft\install\items\ox\items.lua`.

## Image Installation
Copy all images from `sinor-VehicleCraft\install\items_images`.

# qb-inventory:
Paste the images into `qb-inventory\html\images`.
# ox_inventory:
Paste the images into `ox_inventory\web\images`.

# Vehicles images:
- When Adding New Vehicle To Config Add The images To `sinor-VehicleCraft\images` And Do The Config Accordingly.

## Note
- Materials for crafting are intended for QBCore. If using ESX, you’ll need to modify those accordingly.
- Ensure players park the vehicle when crafted, if Not the Vehicle will remain registered to the script.

