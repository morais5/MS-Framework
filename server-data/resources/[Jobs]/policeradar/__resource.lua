resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'PoliceRadar'

ui_page "html/radar.html"

files {
	"html/digital-7.regular.ttf", 
	"html/radar.html",
	"html/radar.css",
	"html/radar.js"
}

client_scripts {
	'config.lua',
	'client/main.lua',
}

server_scripts {
	'config.lua',
	'server/main.lua',
}
