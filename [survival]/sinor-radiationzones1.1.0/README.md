# QBCore/ESX Radiation Zones

This script adds configurable radiation zones to your QBCore or ESX-based FiveM server. Players will receive notifications and effects when entering or leaving these zones. The script supports both QBCore and ESX frameworks.

## Features

- Define radiation zones with specific coordinates and radius.
- Apply visual and health effects to players in the radiation zones.
- Prevent effects if the player has an anti-radiation mask.
- Configurable debug mode.
- Sends notifications to a Discord webhook when players enter or leave radiation zones.

## Requirements

- [qb-core](https://github.com/qbcore-framework/qb-core) (for QBCore)
- [es_extended](https://github.com/ESX-Org/es_extended) (for ESX)
- [mysql-async](https://github.com/brouznouf/fivem-mysql-async) (for server-side event handling)


## Installation

### Step 1: Download and Install

1. **Download the Resource**: Download the latest version of the `sinor-radiationzones` resource.

2. **Extract the Resource**: Extract the downloaded files to your `resources` directory.

3. **Add to Server CFG**: Open your `server.cfg` and add the following line to ensure the resource starts:
    ```
    ensure sinor-radiationzones
    ```

### Step 2: Configure the Script

1. **Edit Config.lua**: Open the `config.lua` file in the `sinor-radiationzones` directory and configure the core framework, radiation zones, and blood loss settings:
    ```lua
    Config = {}

    Config.Core = 'QBCore' -- Choose core, e.g., 'QBCore', 'ESX'

    Config.RadiationZones = {
        {
            coords = vector3(100.0, 100.0, 100.0),
            radius = 100.0,
            blipradius = 100.0,
            showblipradius = true,
            blipradiusscale = 0.9,
            blipradiuscolor = 2,
            blipradiusname = "Radioactive Zone",
        },
        -- Add more zones as needed
    }

    Config.BloodLoss = {
        interval = 20000, -- Interval in milliseconds (20000ms = 20s)
        amount = 5       -- Amount of health to lose each interval
    }
    ```

## Dependencies

- QBCore Framework (if using QBCore)
- ESX Framework (if using ESX)
- ox_inventory (if using ESX)
- qb-inventory (if using QBCore)

  ## ADD ITEM TO UR SERVER
  # QBCore

  ['antiradiationmask'] = {
    name = 'antiradiationmask',
    label = 'Radiation Mask',
    weight = 10,
    type = 'item',
    image = 'antiradiationmask.png',
    unique = false,
    useable = true,
    shouldClose = true,
    description = 'Always use protection',
},

  # ESX "using ox_inventory" or add it to the sql

	["antiradiationmask"] = {
		label = "antiradiation mask",
		weight = 10,
		stack = true,
		close = true,
	},


