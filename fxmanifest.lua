fx_version 'adamant'

game 'gta5'

author 'fxDopa#1648'

description 'VEHICLE LOCK WITH ANIMATION AND SOUNDS FXDOPA '

version '2.0'

server_script {
	'@oxmysql/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'client/main.lua'
}

dependencies {
	'es_extended'
}
