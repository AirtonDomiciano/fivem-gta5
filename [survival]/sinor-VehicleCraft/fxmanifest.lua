fx_version 'cerulean'
game 'gta5'

author 'SinorSystem'
description 'Vehicle Crafting System'
version '1.3.1'
lua54 'yes'

shared_scripts {
    "@ox_lib/init.lua",
    'config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

files {
    'images/*.png'
}


escrow_ignore {
    'config.lua',
    "install/items/esx/items.sql",
    "install/items/qb/items.lua",
    "install/items/ox/items.lua"
  }


dependency '/assetpacks'