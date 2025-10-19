fx_version 'cerulean'
games { 'gta5' }

author 'Sinor-System'
description 'Advanced Zombie System'
version '1.7.5'
lua54 'yes'

shared_script {
 '@ox_lib/init.lua',
 'config.lua'
}

server_scripts {
    'server/sv_zombies.lua',
    'server/sv_specialzombies.lua',
    'server/sv_animals.lua',
    'server/sv_npcspawner.lua'
}

client_scripts {
    "@PolyZone/client.lua",
    'client/cl_zombies.lua',
    'client/cl_main.lua',
    'client/cl_SpecialZombies.lua',
    'client/cl_animals.lua',
    'client/cl_npcspawner.lua',
    'client/cl_exports.lua' 

}

files {
    'html/index.html',
    'html/sounds/*.ogg'
}

ui_page 'html/index.html'

dependency {
    'ox_lib',
    'PolyZone'
}

escrow_ignore {
    'config.lua', 
    'stream/*/*.ydd',
    'stream/*/*.yft',
    'stream/*/*.ymt',
    'stream/*/*.ytd',
    -- 'client/cl_zombies.lua',
    -- 'client/cl_main.lua',
    -- 'client/cl_SpecialZombies.lua',
    -- 'client/cl_npcspawner.lua',
    -- 'client/cl_animals.lua',
    -- 'client/cl_exports.lua',
    -- 'server/sv_zombies.lua',
    -- 'server/sv_specialzombies.lua',
    -- 'server/sv_animals.lua',
    -- 'server/sv_npcspawner.lua',
    -- 'html/index.html'
  }





dependency '/assetpacks'