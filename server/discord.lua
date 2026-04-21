-- =====================================================
-- Discord REST API layer
-- Handles auth headers, rate limiting retries, and JSON
-- =====================================================
Discord = {}

local lastRequestAt = 0

local function sleep(ms)
    Wait(ms)
end

-- Low-level HTTP request to Discord. Returns: ok(bool), data(table|string), status(number)
function Discord.Request(method, endpoint, body, attempt)
    attempt = attempt or 1

    if not Config.BotToken or Config.BotToken == '' then
        Utils.Error('Bot token is not set. Use `set discord_bot_token "..."` in server.cfg.')
        return false, 'no_token', 0
    end

    -- gap between calls to reduce burst 429s
    local sinceLast = GetGameTimer() - lastRequestAt
    if sinceLast < Config.RateLimit.requestGap then
        sleep(Config.RateLimit.requestGap - sinceLast)
    end

    local url = Config.APIBase .. endpoint
    local headers = {
        ['Authorization'] = 'Bot ' .. Config.BotToken,
        ['Content-Type']  = 'application/json',
        ['User-Agent']    = 'C8N_Discord_API (FiveM, 1.0)'
    }

    local p = promise.new()

    PerformHttpRequest(url, function(status, responseText, responseHeaders)
        lastRequestAt = GetGameTimer()
        p:resolve({ status = status, body = responseText, headers = responseHeaders })
    end, method, body and json.encode(body) or '', headers)

    local res  = Citizen.Await(p)
    local code = res.status or 0

    Utils.Log(method, endpoint, '->', code)

    -- handle rate-limit
    if code == 429 and attempt <= Config.RateLimit.maxRetries then
        local retryAfter = Config.RateLimit.retryDelay * attempt
        local ok, parsed = pcall(json.decode, res.body)
        if ok and parsed and parsed.retry_after then
            retryAfter = math.ceil(parsed.retry_after * 1000) + 100
        end
        Utils.Log('Rate limited. Retrying in', retryAfter, 'ms (attempt', attempt, ')')
        sleep(retryAfter)
        return Discord.Request(method, endpoint, body, attempt + 1)
    end

    if code < 200 or code >= 300 then
        return false, res.body, code
    end

    if res.body and #res.body > 0 then
        local ok, data = pcall(json.decode, res.body)
        if ok then return true, data, code end
        return true, res.body, code
    end

    return true, {}, code
end

-- Convenience helpers
function Discord.Get(endpoint)
    return Discord.Request('GET', endpoint, nil)
end

function Discord.Post(endpoint, body)
    return Discord.Request('POST', endpoint, body)
end

-- =====================================================
-- Identifier extraction
-- =====================================================

-- Returns Discord user id (string) from a FiveM source, or nil
function Discord.GetUserId(source)
    if not source then return nil end
    local ids = GetPlayerIdentifiers(source)
    if not ids then return nil end
    for _, id in ipairs(ids) do
        if id:sub(1, 8) == 'discord:' then
            return id:sub(9)
        end
    end
    return nil
end

-- =====================================================
-- Low-level fetchers (used by higher-level modules)
-- =====================================================

function Discord.FetchGuild()
    local key = 'guild:' .. Config.GuildID
    local cached = Cache.Get(key)
    if cached then return cached end

    local ok, data = Discord.Get('/guilds/' .. Config.GuildID .. '?with_counts=true')
    if not ok then
        Utils.Error('Failed to fetch guild:', data)
        return nil
    end
    Cache.Set(key, data, Config.Cache.guildTTL)
    return data
end

function Discord.FetchGuildRoles()
    local key = 'roles:' .. Config.GuildID
    local cached = Cache.Get(key)
    if cached then return cached end

    local ok, data = Discord.Get('/guilds/' .. Config.GuildID .. '/roles')
    if not ok then
        Utils.Error('Failed to fetch roles:', data)
        return nil
    end
    Cache.Set(key, data, Config.Cache.roleListTTL)
    return data
end

function Discord.FetchMember(userId)
    if not userId then return nil end
    local key = 'member:' .. userId
    local cached = Cache.Get(key)
    if cached then return cached end

    local ok, data, code = Discord.Get('/guilds/' .. Config.GuildID .. '/members/' .. userId)
    if not ok then
        if code ~= 404 then
            Utils.Error('Failed to fetch member', userId, ':', data)
        end
        return nil
    end
    Cache.Set(key, data, Config.Cache.memberTTL)
    return data
end

function Discord.FetchUser(userId)
    if not userId then return nil end
    local key = 'user:' .. userId
    local cached = Cache.Get(key)
    if cached then return cached end

    local ok, data = Discord.Get('/users/' .. userId)
    if not ok then
        Utils.Error('Failed to fetch user', userId, ':', data)
        return nil
    end
    Cache.Set(key, data, Config.Cache.memberTTL)
    return data
end
