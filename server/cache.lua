-- =====================================================
-- Simple TTL cache used by Discord API layer
-- =====================================================
Cache = {}

local store = {}

local function now()
    return os.time()
end

function Cache.Set(key, value, ttl)
    if not Config.Cache.enabled then return end
    store[key] = {
        value   = value,
        expires = now() + (ttl or 60)
    }
end

function Cache.Get(key)
    if not Config.Cache.enabled then return nil end
    local entry = store[key]
    if not entry then return nil end
    if entry.expires < now() then
        store[key] = nil
        return nil
    end
    return entry.value
end

function Cache.Invalidate(key)
    store[key] = nil
end

function Cache.Clear()
    store = {}
end

-- periodic cleanup
CreateThread(function()
    while true do
        Wait(60000)
        local t = now()
        for k, v in pairs(store) do
            if v.expires < t then store[k] = nil end
        end
    end
end)
