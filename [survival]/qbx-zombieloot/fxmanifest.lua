fx_version 'cerulean'
game 'gta5'

author 'Seu Nome'
description 'Sistema de Loot para NPCs/Zumbis Mortos - QBX Compatible'
version '1.0.0'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}

dependencies {
    'ox_lib',
    'qbx_core',
    'ox_inventory'
}