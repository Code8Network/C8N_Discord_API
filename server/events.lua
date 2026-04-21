-- =====================================================
-- Events: startup check + splash data delivery
-- =====================================================

AddEventHandler('onResourceStart', function(res)
    if res ~= GetCurrentResourceName() then return end

    CreateThread(function()
        Wait(500)
        if not Config.BotToken or Config.BotToken == '' then
            Utils.Error('No bot token configured. Set `discord_bot_token` convar in server.cfg.')
            return
        end
        if not Config.GuildID or Config.GuildID == '' or Config.GuildID == '000000000000000000' then
            Utils.Error('No guild id configured. Set `discord_guild_id` convar in server.cfg.')
            return
        end

        local g = Discord.FetchGuild()
        if g and g.name then
            Utils.Info(('Connected to Discord guild "%s" (%s members).'):format(
                g.name, g.approximate_member_count or '?'))
        else
            Utils.Error('Could not fetch guild. Verify token, guild id, and bot membership.')
        end
    end)
end)

-- Client -> server: request splash data when it wants to render the splash
RegisterNetEvent('C8N_Discord_API:requestSplash', function()
    local src = source
    if not Config.Splash.enabled then
        TriggerClientEvent('C8N_Discord_API:splashData', src, nil)
        return
    end

    local info = Guild.GetInfo() or {}
    TriggerClientEvent('C8N_Discord_API:splashData', src, {
        title       = Config.Splash.title,
        subtitle    = Config.Splash.subtitle,
        background  = Config.Splash.background,
        discord     = Config.Splash.discord,
        website     = Config.Splash.website,
        duration    = Config.Splash.duration,
        guildName   = info.name,
        guildIcon   = info.icon,
        memberCount = info.memberCount,
        onlineCount = info.onlineCount,
    })
end)

-- Handy admin command: dump current player's Discord data to console
RegisterCommand('discordinfo', function(source, args)
    if source == 0 then
        print('This command must be run by a player.')
        return
    end
    local data = User.GetData(source)
    if not data then
        TriggerClientEvent('chat:addMessage', source, {
            args = { '[C8N Discord]', 'No Discord identifier found. Is your Discord running?' }
        })
        return
    end
    TriggerClientEvent('chat:addMessage', source, {
        args = { '[C8N Discord]', ('%s (%s) - %d roles'):format(
            data.nickname or data.username or '?', data.id, #(data.roles or {})) }
    })
end, false)
