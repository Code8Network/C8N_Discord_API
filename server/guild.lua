-- =====================================================
-- Guild (server) level information
-- =====================================================
Guild = {}

function Guild.GetRaw()
    return Discord.FetchGuild()
end

function Guild.GetName()
    local g = Guild.GetRaw()
    return g and g.name or nil
end

function Guild.GetIcon(size)
    size = size or 256
    local g = Guild.GetRaw()
    if not g or not g.icon then return nil end
    return ('https://cdn.discordapp.com/icons/%s/%s.png?size=%d'):format(g.id, g.icon, size)
end

function Guild.GetSplash(size)
    size = size or 1024
    local g = Guild.GetRaw()
    if not g or not g.splash then return nil end
    return ('https://cdn.discordapp.com/splashes/%s/%s.png?size=%d'):format(g.id, g.splash, size)
end

function Guild.GetBanner(size)
    size = size or 1024
    local g = Guild.GetRaw()
    if not g or not g.banner then return nil end
    return ('https://cdn.discordapp.com/banners/%s/%s.png?size=%d'):format(g.id, g.banner, size)
end

-- Approximate total member count (requires with_counts=true on fetch, which we do)
function Guild.GetMemberCount()
    local g = Guild.GetRaw()
    return g and (g.approximate_member_count or 0) or 0
end

-- Approximate online/presence count
function Guild.GetOnlineCount()
    local g = Guild.GetRaw()
    return g and (g.approximate_presence_count or 0) or 0
end

-- Returns the full role list
function Guild.GetRoles()
    return Roles.GetAll()
end

-- Convenience bundle
function Guild.GetInfo()
    local g = Guild.GetRaw()
    if not g then return nil end
    return {
        id          = g.id,
        name        = g.name,
        icon        = Guild.GetIcon(),
        splash      = Guild.GetSplash(),
        banner      = Guild.GetBanner(),
        memberCount = g.approximate_member_count or 0,
        onlineCount = g.approximate_presence_count or 0,
        description = g.description,
        roles       = Guild.GetRoles(),
    }
end
