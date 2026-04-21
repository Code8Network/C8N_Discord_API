-- Shared utilities used by client and server

Utils = {}

function Utils.Log(...)
    if Config and Config.Debug then
        print('[C8N_Discord_API]', ...)
    end
end

function Utils.Error(...)
    print('^1[C8N_Discord_API][ERROR]^7', ...)
end

function Utils.Info(...)
    print('^2[C8N_Discord_API]^7', ...)
end

-- Case-insensitive string compare
function Utils.IEquals(a, b)
    if type(a) ~= 'string' or type(b) ~= 'string' then return false end
    return a:lower() == b:lower()
end
