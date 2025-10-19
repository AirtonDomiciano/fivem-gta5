fx_version 'cerulean'
games { 'rdr3', 'gta5' }

author 'Dannyfjsf'
description 'Armour script with lots of features'
lua54 'yes'
version '1.2.2'

client_scripts {
    'client/client.lua'
}

server_scripts{
    'server/server.lua',
    '@oxmysql/lib/MySQL.lua',
    
}

shared_script{
    'config.lua',
    '@ox_lib/init.lua'
}


dependencies{
    'oxmysql',
    'ox_lib'
}

escrow_ignore {
    'server/*',
    'client/*',
    'config.lua'
}
dependency '/assetpacks'