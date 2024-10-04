onGuard = {}

function onGuard.TriggerServer(_eventName, ...)
    LOG.Debug('TriggerServer [C->S]     ' .. _eventName)
    TriggerServerEvent(_eventName, ...)
end

function onGuard.Thread(fn)
    Citizen.CreateThread(fn)
end

function onGuard.Wait(timeInterval)
    Citizen.Wait(timeInterval)
end

function onGuard.OnNet(_eventName, eventFn)
    RegisterNetEvent(_eventName, eventFn)
end

local RequestId = 0
local serverRequests = {}

---@param eventName string
---@param callback function
---@vararg any
function onGuard.TriggerServerCallback(eventName, callback, ...)
    serverRequests[RequestId] = callback

    TriggerServerEvent("onGuard:triggerServerCallback", eventName, RequestId, GetInvokingResource() or "unknown", ...)

    RequestId = RequestId + 1
end

RegisterNetEvent("onGuard:serverCallback", function(requestId, invoker, ...)
    if not serverRequests[requestId] then
        return
    end

    serverRequests[requestId](...)
    serverRequests[requestId] = nil
end)
