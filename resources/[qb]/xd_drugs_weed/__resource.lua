resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

description 'qb_weed'

server_scripts {
	--'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server/weedplant.lua'
}

client_scripts {

	'config.lua',
	'client/weedplant.lua'
}