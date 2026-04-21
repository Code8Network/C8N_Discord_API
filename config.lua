Config = {}

-- =====================================================
-- C8N Discord API - Main Configuration
-- =====================================================

-- Your Discord bot token. Create a bot at https://discord.com/developers/applications
-- The bot MUST be invited to your guild with at least the following intents/permissions:
--   * View Channels, Read Members, Read Roles
--   * Privileged Intent: SERVER MEMBERS INTENT (required to fetch member data)
-- SECURITY: Never commit your real token. Use convar `set discord_bot_token "..."` in server.cfg
Config.BotToken = GetConvar('discord_bot_token', '')

-- Your Discord Guild (server) ID. Right-click your server -> Copy Server ID (Developer Mode).
Config.GuildID = GetConvar('discord_guild_id', '000000000000000000')

-- Discord API base URL (v10 is current stable)
Config.APIBase = 'https://discord.com/api/v10'

-- =====================================================
-- Caching
-- =====================================================
Config.Cache = {
    enabled      = true,
    roleListTTL  = 300,  -- seconds - role list refresh interval
    memberTTL    = 120,  -- seconds - per-member cache lifetime
    guildTTL     = 600,  -- seconds - guild info cache lifetime
}

-- =====================================================
-- Rate limiting safety
-- =====================================================
Config.RateLimit = {
    maxRetries  = 3,
    retryDelay  = 1000,  -- ms base delay when hitting 429
    requestGap  = 50,    -- ms minimum gap between requests
}

-- =====================================================
-- RoleList - friendly role name -> permission mapping
-- Use these names in your scripts instead of raw IDs.
-- Example:  exports['C8N_Discord_API']:HasRole(source, 'Admin')
-- =====================================================
Config.RoleList = {
    ['Owner']     = 'Owner',
    ['Admin']     = 'Admin',
    ['Moderator'] = 'Moderator',
    ['Developer'] = 'Developer',
    ['Staff']     = 'Staff',
    ['VIP']       = 'VIP',
    ['Donator']   = 'Donator',
    ['Member']    = 'Member',
    ['Whitelist'] = 'Whitelist',
}

-- =====================================================
-- Splash Screen (optional)
-- =====================================================
Config.Splash = {
    enabled     = true,
    duration    = 8000,   -- ms to show on join (0 = until dismissed)
    title       = 'Welcome to our Server',
    subtitle    = 'Powered by C8N Discord API',
    background  = 'https://i.imgur.com/placeholder.png',  -- replace with your image URL
    discord     = 'https://discord.gg/yourinvite',
    website     = 'https://yourwebsite.com',
}

-- =====================================================
-- Logging
-- =====================================================
Config.Debug = false  -- print verbose Discord API logs to server console
