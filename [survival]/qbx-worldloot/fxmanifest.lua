fx_version 'cerulean'
game 'gta5'

author 'World Loot System'
description 'Sistema de Loot Dinâmico para Casas, Veículos e Props - Servidor Zumbi'
version '2.0.0'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua',
    'client/zones.lua'
}

server_scripts {
    'server/main.lua'
}

dependencies {
    'ox_lib',
    'qbx_core',
    'ox_inventory'
}