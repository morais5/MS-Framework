resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_scripts {
    'client/main.lua',
    'client/deliveries.lua',
    'client/cornerselling.lua',
    'config.lua',
}

server_scripts {
    'server/main.lua',
    'server/deliveries.lua',
    'server/cornerselling.lua',
    'config.lua',
}

server_exports {
    'GetDealers'
}