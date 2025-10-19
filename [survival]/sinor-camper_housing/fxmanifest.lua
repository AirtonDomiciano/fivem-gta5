fx_version 'cerulean'
game 'gta5'

author 'SinorSystem'
description 'vehicle housing Script for QBCore and ESX with stash and clothing....'
version '1.2.5'
lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'Utility.lua',
    'config.lua'
}

client_scripts {
    'qb-target-bridge.lua',
    'client/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

escrow_ignore {
    'config.lua',  
  }


dependency '/assetpacks'