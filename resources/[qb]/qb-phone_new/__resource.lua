resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page "html/index.html"

client_scripts {
    'client/main.lua',
    'client/animation.lua',
    '@qb-garages/SharedConfig.lua',
    '@qb-apartments/config.lua',
    'config.lua',
}

server_scripts {
    'server/main.lua',
    '@qb-garages/SharedConfig.lua',
    '@qb-apartments/config.lua',
    'config.lua',
}

files {
    'html/*.html',
    'html/js/*.js',
    'html/img/*.png',
    'html/css/*.css',
    'html/fonts/*.ttf',
    'html/fonts/*.otf',
    'html/fonts/*.woff',
    'html/img/backgrounds/*.png',
    'html/img/apps/*.png',
}