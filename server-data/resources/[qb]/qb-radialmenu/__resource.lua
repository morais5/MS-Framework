resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

ui_page "html/index.html"

client_scripts {
    "client/main.lua",
    "client/trunk.lua",
    "client/brancard.lua",
	"config.lua",
}

server_scripts {
	"server/main.lua",
    "config.lua",
    "server/trunk.lua",
    "server/brancard.lua",
}

files {
    'html/index.html',
    'html/css/main.css',
    'html/css/RadialMenu.css',
    'html/js/main.js',
    'html/js/RadialMenu.js',
}