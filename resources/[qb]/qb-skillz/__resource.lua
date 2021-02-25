
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

server_scripts {
    'server/main.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua',
    'config.lua',
    'client/functions.lua'
}

exports {
    "SkillMenu",
    "UpdateSkill",
    "GetCurrentSkill"
}