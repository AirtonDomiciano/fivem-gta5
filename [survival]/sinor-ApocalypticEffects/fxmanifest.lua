fx_version "cerulean"
game "gta5"
description 'Add post apocalyptic effects that will make ur server mroe alive or dead!'
author 'Sinor System'
version '1.1.0'
lua54 "yes"

shared_scripts {
	"config.lua"
}

client_scripts {
	"client/main.lua"
}
server_scripts {
	"server/main.lua"
}

ui_page 'html/sound.html'

files {
    'html/sound.html',
    'html/earthquake.mp3',
    'data/w_neutral.xml',
    'data/weather.xml',
}

data_file 'TIMECYCLEMOD_FILE' 'w_neutral.xml'
data_file 'TIMECYCLEMOD_FILE' 'weather.xml'

escrow_ignore {
    'config.lua',
  }




dependency '/assetpacks'