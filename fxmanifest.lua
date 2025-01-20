fx_version 'cerulean'
game 'gta5'

author 'error950'
description 'Advanced Clothing Stores'
version '1.0'

client_scripts {
    'src/RageUI.lua',
    'src/Menu.lua',
    'src/MenuController.lua',
    'src/components/*.lua',
    'src/elements/*.lua',
    'src/items/*.lua',
    'client/cl_*.lua'
}
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/sv_*.lua'
}

shared_scripts {
    'config.lua'
}