fx_version 'adamant'
games { 'gta5' }
author 'Helli'
description 'Individually Sectioned Tattoo Shop for msus'
name 'WCKD TattooShop'
client_scripts {
	'menu.lua',
	'config.lua',
	'client.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua', --- Dont worry its already installed on msus or atleast should be
	'server.lua'
}

file 'AllTattoos.json'
