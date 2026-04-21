-- =====================================================
-- Public exports for other resources
--
-- Usage example:
--   local api = exports['C8N_Discord_API']
--   if api:HasRole(source, 'Admin') then ... end
--   local info = api:GetPlayerData(source)
-- =====================================================

-- -------- Identity --------
exports('GetDiscordId',       function(source)       return Discord.GetUserId(source) end)
exports('IsInGuild',          function(source)       return User.IsInGuild(source) end)

-- -------- Roles --------
exports('HasRole',            function(source, name) return Roles.MemberHasRole(source, name) end)
exports('HasAnyRole',         function(source, t)    return Roles.MemberHasAnyRole(source, t) end)
exports('HasAllRoles',        function(source, t)    return Roles.MemberHasAllRoles(source, t) end)
exports('GetPlayerRoles',     function(source)
    local id = Discord.GetUserId(source)
    return id and Roles.GetMemberRoleNames(id) or {}
end)
exports('GetPlayerRoleIds',   function(source)
    local id = Discord.GetUserId(source)
    return id and Roles.GetMemberRoleIds(id) or {}
end)
exports('GetRoleIdByName',    function(name)         return Roles.GetIdByName(name) end)
exports('GetRoleByName',      function(name)         return Roles.GetByName(name) end)
exports('GetAllRoles',        function()             return Roles.GetAll() end)

-- -------- Player / user --------
exports('GetPlayerName',      function(source)       return User.GetName(source) end)
exports('GetPlayerNickname',  function(source)       return User.GetNickname(source) end)
exports('GetPlayerAvatar',    function(source, size) return User.GetAvatar(source, size) end)
exports('GetPlayerEmail',     function(source)       return User.GetEmail(source) end)
exports('GetPlayerData',      function(source)       return User.GetData(source) end)

-- -------- Guild / server --------
exports('GetGuildName',       function()             return Guild.GetName() end)
exports('GetGuildIcon',       function(size)         return Guild.GetIcon(size) end)
exports('GetGuildSplash',     function(size)         return Guild.GetSplash(size) end)
exports('GetGuildBanner',     function(size)         return Guild.GetBanner(size) end)
exports('GetGuildMemberCount',function()             return Guild.GetMemberCount() end)
exports('GetGuildOnlineCount',function()             return Guild.GetOnlineCount() end)
exports('GetGuildInfo',       function()             return Guild.GetInfo() end)

-- -------- Cache control --------
exports('InvalidateMember',   function(userIdOrSource)
    local id = type(userIdOrSource) == 'number' and Discord.GetUserId(userIdOrSource) or userIdOrSource
    if id then
        Cache.Invalidate('member:' .. id)
        Cache.Invalidate('user:' .. id)
    end
end)
exports('InvalidateRoles',    function() Cache.Invalidate('roles:' .. Config.GuildID) end)
exports('InvalidateGuild',    function() Cache.Invalidate('guild:' .. Config.GuildID) end)
exports('ClearCache',         function() Cache.Clear() end)
