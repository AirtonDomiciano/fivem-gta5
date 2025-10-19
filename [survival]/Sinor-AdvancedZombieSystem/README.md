# Sinor-AdvancedZombieSystem
Sinor-AdvancedZombieSystem is a custom zombie spawning system for FiveM, featuring dynamic zombie behavior, custom sound integration with Sounity and xsound, and configurable redzones points where zombies will spawn and attack players. The system is optimized to handle zombies while maintaining performance and immersion.

# Features

- Fully Configurable.
- Synced Zombies using onesync or deafult client side.
- Dynamic Zombie using FiveM native Ped Density or Spawn System or Both
- Custom Zombie Behavior: Includes custom animations, health, and combat settings to make zombies more challenging.
- 3D Zombie Sounds to provide immersive sound effects for zombie groans, attacks, and group behaviors.
- redzones : its a spawning zone for zombies you can choose Zone Zombie Limit and Spawn Distance and Zombies models.
- Safe Zones: Designated areas where zombies are automatically removed, ensuring player safety.
- Excluded Peds : Peds that can spawn normally and can be used in shops and other things.
- StrongerZombies : {model = "a_m_o_acult_02", hp = 900}, -- Example stronger zombie.
- OnFire zombies and Gas zombies and Runner zombies.
- FireZones : zones that keep all zombies on fire
- sounds from shooting and running and using vehicles noises can attract zombies.
- Vehicle Density so Players can find Parked vehicles to use.
- Vehicle Damage allow zombies to damage vehicle engine when players are inside.
- in Vehicle Damage allow zombies to damage players inside vehicles.
- Enable or disable headshot insta-kills for zombies.
- you can Enable or disable zombies spawning in safe zones, you can use it for event!
- and much More!


# dependences
## sound
- one of them:
[Sounity](https://github.com/araynimax/sounity)
[xsound](https://github.com/Xogy/xsound)
## notify
ox_lib
## zones
PolyZone

# Installation

Download and Install Dependencies:

- Ensure you have Sounity or xsound installed in your FiveM server. Follow the instructions from the Sounity GitHub repository.
- Add Sinor-AdvancedZombieSystem to your FiveM resources directory.
- Add to Server Configuration: Add start Sinor-AdvancedZombieSystem to your server.cfg to ensure the resource starts with your server.

# exports
```lua
exports["Sinor-AdvancedZombieSystem"]:TriggerZombieAttractionToEntity(playerPed, 50)  -- Attract zombies to player within 50m

exports["Sinor-AdvancedZombieSystem"]:TriggerZombieSpawn(GetEntityCoords(playerPed), 30, 5)  -- Spawns 5 zombies within 30m
```
# example
```lua
-------------------------- example using proximity chat
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500) 
        if MumbleIsPlayerTalking(PlayerId()) then
            local playerPed = PlayerPedId()
            exports["Sinor-AdvancedZombieSystem"]:TriggerZombieAttractionToEntity(playerPed, Config.PlayerTalkingRange)
        end
    end
end)
```

# Discord : https://discord.gg/uPkwE87CzW