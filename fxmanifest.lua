fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'C8N'
description 'C8N Discord API - Full Discord integration for FiveM (roles, users, guild data, caching, splash)'
version '1.0.0'

shared_scripts {
    'config.lua',
    'shared/utils.lua'
}

server_scripts {
    'server/cache.lua',
    'server/discord.lua',
    'server/roles.lua',
    'server/user.lua',
    'server/guild.lua',
    'server/exports.lua',
    'server/events.lua'
}

client_scripts {
    'client/splash.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}

dependencies {
    '/server:5848'
}
