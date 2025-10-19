-- fxmanifest.lua
fx_version 'cerulean'
game 'gta5'

author 'Seu Nome'
description 'Sistema de dinheiro físico para QBX'
version '1.0.0'

shared_script '@ox_lib/init.lua'
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}