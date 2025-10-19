-- fxmanifest.lua
fx_version 'cerulean'
game 'gta5'

author 'Debug Shop'
description 'Loja de Debug para Testes - QBX Compatible'
version '1.0.0'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

dependencies {
    'ox_lib',
    'qbx_core',
    'ox_inventory'
}

--[[ 
    INSTALAÇÃO:
    1. Crie pasta: resources/[local]/qbx-debugshop/
    2. Crie 3 arquivos: fxmanifest.lua, config.lua, client.lua, server.lua
    3. Adicione no server.cfg: ensure qbx-debugshop
    4. Reinicie o servidor
]]