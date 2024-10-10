onGuard = {}
onGuard.C = {
    _C = {}
}

local serverCallbacks = {}

function onGuard.TriggerClient(_eventName, target, ...)
    LOG.Debug('TriggerClient    ' .. _eventName)
    TriggerClientEvent(_eventName, target, ...)
end

function onGuard.GetPlayers()
    local players = {}

    for k, v in pairs(PlayerInGame) do
        table.insert(players, k)
        break
    end

    return players
end

function onGuard.Thread(fn)
    Citizen.CreateThread(fn)
end

function onGuard.Wait(timeInterval)
    Citizen.Wait(timeInterval)
end

function onGuard.generateToken()
    local charset = "0123456789abcdefghijklmnopqrstuvwxyz"
    local length = 128
    local token = ""

    for i = 1, length do
        local randIndex = math.random(1, #charset)
        token = token .. charset:sub(randIndex, randIndex)
    end

    return token
end

function onGuard.OnNet(_eventName, eventFn)
    RegisterNetEvent(_eventName, eventFn)
end

function onGuard.KickPlayer(id, reason)
    DropPlayer(id, 'you are permanently banned by onGuard Anticheat for ' .. reason)
end

---@param eventName string
---@param callback function
function onGuard.RegisterServerCallback(eventName, callback)
    serverCallbacks[eventName] = callback
end

RegisterNetEvent("onGuard:triggerServerCallback", function(eventName, requestId, invoker, ...)
    if not serverCallbacks[eventName] then
        return
    end

    local source = source

    serverCallbacks[eventName](source, function(...)
        TriggerClientEvent("onGuard:serverCallback", source, requestId, invoker, ...)
    end, ...)
end)
