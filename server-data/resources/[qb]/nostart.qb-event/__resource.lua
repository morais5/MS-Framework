resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page "html/index.html"

client_scripts {
	'client/main.lua',
}

server_scripts {
	'server/main.lua',
}

files {
    'html/videos/*',
	'html/index.html',
	'html/style.css',
    'html/script.js',
}