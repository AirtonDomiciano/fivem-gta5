fx_version 'cerulean'
game 'gta5'

shared_script '@ox_lib/init.lua'

server_script 'sv_arcade.lua'
client_script 'cl_arcade.lua'

dependencies {
    'qbx_core',
    'ox_lib',
    'ox_target',
    'ps-ui'
}
