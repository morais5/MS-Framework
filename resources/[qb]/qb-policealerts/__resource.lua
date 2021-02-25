resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page "html/index.html"

client_scripts {
    'client.lua',
    'config.lua',
}

server_scripts {
    'server.lua',
    'config.lua',
}

files {
    '*.lua',
    'html/*.html',
    'html/*.js',
    'html/*.css',
}