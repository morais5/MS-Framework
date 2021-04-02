fx_version 'adamant'
games { 'gta5' }
author 'Helli'
description 'Individually Sectioned Tattoo Shop for Qbus'
name 'WCKD TattooShop'
client_scripts {
	'menu.lua',
	'config.lua',
	'client.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua', --- Dont worry its already installed on qbus or atleast should be
	'server.lua'
}

file 'AllTattoos.json'
