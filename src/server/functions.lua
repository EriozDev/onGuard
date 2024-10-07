onGuard = {}
onGuard.C = {
    _C = {}
}

local serverCallbacks = {}

function onGuard.TriggerClient(_eventName, target, ...)
    LOG.Debug('TriggerClient [S->C]     ')
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

function onGuard.unSynchronise(t, cb)
    if #t == 0 then
        return
    end

    local time = #t
    local results = {}

    for i = 1, #t, 1 do
        onGuard.CreateThread(function()
            t[i](function(result)
                table.insert(results, result)
                time = time - 1

                if time == 0 then
                    cb(results)
                end
            end)
        end)
    end
end

function onGuard.ResetSynchro(cb)
    onGuard.CreateThread(function()
        Wait(500)
        cb(true)
    end)
end

function onGuard.OnNet(_eventName, eventFn)
    RegisterNetEvent(_eventName, eventFn)
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
