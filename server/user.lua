-- =====================================================
-- User / member data helpers
-- =====================================================
User = {}

local function resolve(sourceOrId)
    if type(sourceOrId) == 'number' then
        return Discord.GetUserId(sourceOrId)
    end
    return sourceOrId
end

-- Returns the raw member object (guild-scoped) or nil
function User.GetMember(sourceOrId)
    local id = resolve(sourceOrId)
    return id and Discord.FetchMember(id) or nil
end

-- Returns the raw user object (global) or nil
function User.GetUser(sourceOrId)
    local id = resolve(sourceOrId)
    return id and Discord.FetchUser(id) or nil
end

-- Discord global username (e.g. "john_doe")
function User.GetName(sourceOrId)
    local m = User.GetMember(sourceOrId)
    if m and m.user and m.user.username then return m.user.username end
    local u = User.GetUser(sourceOrId)
    return u and u.username or nil
end

-- Server nickname (falls back to username)
function User.GetNickname(sourceOrId)
    local m = User.GetMember(sourceOrId)
    if not m then return nil end
    if m.nick and m.nick ~= '' then return m.nick end
    if m.user and m.user.username then return m.user.username end
    return nil
end

-- Returns full avatar URL or nil. Uses server-specific avatar if present.
function User.GetAvatar(sourceOrId, size)
    size = size or 256
    local id = resolve(sourceOrId)
    if not id then return nil end

    local m = Discord.FetchMember(id)
    if m and m.avatar then
        return ('https://cdn.discordapp.com/guilds/%s/users/%s/avatars/%s.png?size=%d'):format(
            Config.GuildID, id, m.avatar, size)
    end
    local user = (m and m.user) or Discord.FetchUser(id)
    if user and user.avatar then
        return ('https://cdn.discordapp.com/avatars/%s/%s.png?size=%d'):format(id, user.avatar, size)
    end
    -- default avatar
    local disc = (user and tonumber(user.discriminator)) or 0
    return ('https://cdn.discordapp.com/embed/avatars/%d.png'):format(disc % 5)
end

-- Email can only be returned if the bot has OAuth2 'email' scope authorization for the user.
-- For bot-only integrations Discord does NOT expose emails. This returns the email if present
-- on the user object, otherwise nil. Most servers will get nil here - that is expected.
function User.GetEmail(sourceOrId)
    local u = User.GetUser(sourceOrId)
    if u and u.email then return u.email end
    return nil
end

-- Convenience bundle
function User.GetData(sourceOrId)
    local id = resolve(sourceOrId)
    if not id then return nil end
    return {
        id       = id,
        username = User.GetName(sourceOrId),
        nickname = User.GetNickname(sourceOrId),
        avatar   = User.GetAvatar(sourceOrId),
        email    = User.GetEmail(sourceOrId),
        roles    = Roles.GetMemberRoleNames(id),
        roleIds  = Roles.GetMemberRoleIds(id),
    }
end

-- Is the Discord user a member of the configured guild?
function User.IsInGuild(sourceOrId)
    return User.GetMember(sourceOrId) ~= nil
end
