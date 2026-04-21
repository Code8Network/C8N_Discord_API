-- =====================================================
-- Role helpers - lookup by NAME instead of ID
-- =====================================================
Roles = {}

-- Returns the full role list (array of { id, name, color, position, ... })
function Roles.GetAll()
    return Discord.FetchGuildRoles() or {}
end

-- Get a role object by its (case-insensitive) name. Returns nil if not found.
function Roles.GetByName(name)
    if not name then return nil end
    local all = Roles.GetAll()
    for _, r in ipairs(all) do
        if Utils.IEquals(r.name, name) then
            return r
        end
    end
    return nil
end

-- Get role id by name (nil if not found)
function Roles.GetIdByName(name)
    local r = Roles.GetByName(name)
    return r and r.id or nil
end

-- Returns an array of role IDs the given Discord user has in the guild
function Roles.GetMemberRoleIds(userId)
    local member = Discord.FetchMember(userId)
    if not member or not member.roles then return {} end
    return member.roles
end

-- Returns an array of role names the given Discord user has in the guild
function Roles.GetMemberRoleNames(userId)
    local ids = Roles.GetMemberRoleIds(userId)
    if #ids == 0 then return {} end

    local all = Roles.GetAll()
    local byId = {}
    for _, r in ipairs(all) do byId[r.id] = r.name end

    local names = {}
    for _, id in ipairs(ids) do
        if byId[id] then names[#names + 1] = byId[id] end
    end
    return names
end

-- Does the given source / Discord user have a role (by name)?
function Roles.MemberHasRole(userIdOrSource, roleName)
    if not roleName then return false end

    local userId
    if type(userIdOrSource) == 'number' then
        userId = Discord.GetUserId(userIdOrSource)
    else
        userId = userIdOrSource
    end
    if not userId then return false end

    -- resolve configured friendly name -> actual role name
    local actualName = Config.RoleList[roleName] or roleName

    local targetRole = Roles.GetByName(actualName)
    if not targetRole then return false end

    local ids = Roles.GetMemberRoleIds(userId)
    for _, id in ipairs(ids) do
        if id == targetRole.id then return true end
    end
    return false
end

-- Check multiple roles at once (OR). Returns true if the member has ANY of them.
function Roles.MemberHasAnyRole(userIdOrSource, roleNames)
    if type(roleNames) ~= 'table' then return false end
    for _, name in ipairs(roleNames) do
        if Roles.MemberHasRole(userIdOrSource, name) then return true end
    end
    return false
end

-- AND - member must have ALL listed roles
function Roles.MemberHasAllRoles(userIdOrSource, roleNames)
    if type(roleNames) ~= 'table' then return false end
    for _, name in ipairs(roleNames) do
        if not Roles.MemberHasRole(userIdOrSource, name) then return false end
    end
    return true
end
