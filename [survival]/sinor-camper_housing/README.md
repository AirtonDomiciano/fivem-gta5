# Camper Van Housing Script for FiveM (QBCore)
This script allows players to use camper vans as mobile homes, where they can store items, change clothing, and isolate themselves from other players using unique interior instances (routing buckets).

# Features

- Unique Stashes: Each player has their own stash inside the van, based on the van's license plate.
- Customizable Vans: Easily add multiple types of vans with custom interiors.
- Players are isolated from each other in their own van shell instances.
- Clothing Menu: Players can change their clothing inside their van.
- Persistent Shells: Van interiors are created dynamically when a player interacts with their vehicle.
- Enter/Exit Mechanics: Players can enter and exit their van shells, with their position saved and restored when leaving.

## Requirements

- qb-core: Core framework for QBCore.
- qb-target: Targeting system for interactions.
- illenium-appearance or qb-clothing (Optional): If you want to use the clothing menu inside the van.

# Installation Steps
- add this to server.cfg

`ensure sinor-camper_housing`

# Config


```lua
Config = {}

Config.Core = 'QBCore'  -- CoreObject if renamed
Config.CoreGetCoreObject = 'qb-core' -- Name of the core resource folder
Config.Target_script = 'qb-target' -- Name of the target resource
Config.interior_script = 'qb-interior' -- Name of the interior resource
Config.clothing_event = 'illenium-appearance:client:openClothingShopMenu' -- Event to open van clothing menu
-- note : i used shell in the first camper only you can use map but jest create a shell for the van to work
Config.Vans = {
    ['camper1'] = { -- First van configuration
        Vehicle = "journey",        -- Van model name
        Shell = "shell_trailer",    -- Shell model name
        Shell_Coords = vector3(507.84, 1774.81, 155.5), -- Where the shell is spawned
        Enter_coords = vector3(506.4, 1772.96, 158.4),  -- Player tp to this point when entering the van
        Shell_Clothing = vector3(502.39, 1773.63, 158.4), -- Clothing area inside shell
        Shell_Stash = vector3(509.78, 1773.58, 158.41), -- Stash area inside shell
        Shell_Exit = vector3(506.4, 1772.96, 158.4),  -- Exit point inside shell
        stash_options = { maxweight = 10000, slots = 15 } -- Stash settings for this van
    },
    ['camper2'] = { 
    Vehicle = "camper",         
    Shell = "shell_trailer",    -- here am using map but for the van to work you have to create a shell for it "any shell"
        Shell_Coords = vector3(631.72, 1772.2, 159.29), 
        Enter_coords = vector3(-506.58, -220.88, 27.11),  
        Shell_Clothing = vector3(-507.56, -218.19, 27.1), 
        Shell_Stash = vector3(-505.59, -219.78, 27.11), 
        Shell_Exit = vector3(-506.58, -220.86, 27.11),  
        stash_options = { maxweight = 20000, slots = 25 } 
    },
    ['camper3'] = { 
    Vehicle = "brickade",         
    Shell = "shell_trailer",    -- here am using map but for the van to work you have to create a shell for it "any shell"
    Shell_Coords = vector3(-330.93, 1595.52, 213.14), 
    Enter_coords = vector3(696.52, 1323.45, 243.97),  
    Shell_Clothing = vector3(697.13, 1329.77, 243.97), 
    Shell_Stash = vector3(697.9, 1327.68, 244.02), 
    Shell_Exit = vector3(696.52, 1323.45, 243.97),  
    stash_options = { maxweight = 40000, slots = 35 } 
   },
   ['camper4'] = { 
   Vehicle = "brickade2",         
   Shell = "shell_trailer",    -- here am using map but for the van to work you have to create a shell for it "any shell"
   Shell_Coords = vector3(-330.93, 1595.52, 213.14), 
   Enter_coords = vector3(715.98, 1324.05, 243.97),  
   Shell_Clothing = vector3(716.14, 1329.83, 243.97), 
   Shell_Stash = vector3(717.24, 1324.55, 243.97), 
   Shell_Exit = vector3(715.75, 1323.41, 243.97), 
   stash_options = { maxweight = 50000, slots = 50 } 
   },
    -- Add as many vans as needed
}
```
# Database (MySQL)

- The script uses the player_vehicles table to check ownership of the vans. Ensure your vehicle system saves the license plate and citizenid in this table.

# Add Camper Vans
- Players can use any of the configured camper vans to access their mobile home. Simply approach the van and interact with it (via qb-target).

# Enter the Van
- Players can enter their van by interacting with it. The script will isolate them in their own instance (routing bucket) and teleport them to the shell interior.

# Features Inside the Van

- Stash: Players can store items in a unique stash that is tied to their van's license plate.
- Clothing Menu: Players can access the clothing menu inside their van (if configured).
- Exit: Players can leave the van using the exit interaction, which will return them to the location outside the van where they entered.

# Multiple Vehicle Types

You can add as many Vehicle types as you like in the config.lua file, specifying different models, shells, stash settings, and interaction points.

# Adding More Vehicle

- To add more camper vans to the configuration:

- Open config.lua.
- Add a new entry under Config.Vans like the existing ones.
- Specify the van model, shell, and all interaction points (e.g., clothing, stash, exit).
- Example:

```lua
['camper3'] = {
    Vehicle = "brickade",
    Shell = "shell_trailer",
    Shell_Coords = vector3(-330.93, 1595.52, 213.14),
    Enter_coords = vector3(696.52, 1323.45, 243.97),
    Shell_Clothing = vector3(697.13, 1329.77, 243.97),
    Shell_Stash = vector3(697.9, 1327.68, 244.02),
    Shell_Exit = vector3(696.52, 1323.45, 243.97),
    stash_options = { maxweight = 40000, slots = 35 }
},
```
# Debugging

- Routing Buckets: The script uses routing buckets to isolate players inside the van shells. Each player is assigned their own routing bucket (instance), ensuring they cannot see or interact with other players inside their van.

# Discord : https://discord.gg/uPkwE87CzW



