fx_version 'cerulean'
game 'gta5'

author 'SinorSystem'
description 'Radiation Zones'
version '1.0.0'
lua54 'yes'

shared_scripts {
    'config.lua'
}

client_scripts {
    "client/main.lua"
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    "server/main.lua"
}

escrow_ignore {
    'config.lua',  
  }


dependency '/assetpacks'