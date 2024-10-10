-- [[ onGuard ]] --

games { 'gta5' }
fx_version 'cerulean'
lua54 'yes'

author 'xyz / Erioz'
description 'onGuard AntiCheat'
Version("0.1.0")

shared_scripts {
    'src/shared/cfg.lua',
    'src/shared/libs/log.lua',
}

client_scripts {
    'src/client/functions.lua',
    'src/client/entity.lua',
    'src/client/clientClass.lua',
    'src/client/main.lua',
    'src/client/security/mainSecurity.lua',
    'src/client/security/triggers.lua',
    'src/client/security/import.lua'
}

server_scripts {
    '@onGuard/src/server/functions.lua',
    '@mysql-async/lib/MySQL.lua',
    'src/server/functions.lua',
    'src/server/entity.lua',
    'src/server/main.lua',
    'src/server/security/mainSecurity.lua',
    'src/server/security/triggers.lua'
}
