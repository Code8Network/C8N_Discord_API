-- =====================================================
-- Splash screen client
-- =====================================================

local splashOpen = false

local function setNui(open, data)
    splashOpen = open
    SetNuiFocus(open, open)
    SendNUIMessage({
        action = open and 'show' or 'hide',
        data   = data or {}
    })
end

RegisterNetEvent('C8N_Discord_API:splashData', function(data)
    if not data then return end
    setNui(true, data)

    if data.duration and data.duration > 0 then
        SetTimeout(data.duration, function()
            if splashOpen then setNui(false) end
        end)
    end
end)

RegisterNUICallback('close', function(_, cb)
    setNui(false)
    cb({ ok = true })
end)

RegisterNUICallback('openUrl', function(data, cb)
    if data and data.url then
        -- FiveM can't open external URLs directly; show clipboard hint instead
        SendNUIMessage({ action = 'copied', url = data.url })
    end
    cb({ ok = true })
end)

AddEventHandler('playerSpawned', function()
    -- small delay so UI feels smooth
    SetTimeout(1500, function()
        TriggerServerEvent('C8N_Discord_API:requestSplash')
    end)
end)

RegisterCommand('splash', function()
    TriggerServerEvent('C8N_Discord_API:requestSplash')
end, false)
