fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Your Name'
description 'Vehicle Tuning System for QBX Core'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua',
    'client/npc.lua'
}

server_scripts {
    'server/main.lua'
}

dependencies {
    'qbx_core',
    'ox_lib',
    'ox_target',
    'ox_inventory'
}