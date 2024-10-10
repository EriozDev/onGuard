protectedEvent = {}

onGuard.OnNet('onGuard:syncEvent', function(event)
    protectedEvent = event
end)

---@param _eventName string
function onGuard.TriggerServerEvent(_eventName, ...)
    if _eventName == nil then
        return
    end

    if not protectedEvent[_eventName] then
        LOG.Error('onGuard.TriggerServerEvent the eventName is not valid!')
        return
    end

    TriggerServerEvent(_eventName, protectedEvent[_eventName], ...)
end

---@param _eventName string
---@param time number
function onGuard.TriggerServerTimeEvent(_eventName, time, ...)
    if _eventName == nil then
        return
    end

    if not protectedEvent[_eventName] then
        LOG.Error('onGuard.TriggerServerTimeEvent the eventName is not valid!')
        return
    end

    onGuard.Wait(time)
    TriggerServerEvent(_eventName, protectedEvent[_eventName], ...)
end

---@param _eventName string
function onGuard.GetTokenByEventName(_eventName)
    return protectedEvent[_eventName] ~= nil
end

onGuard.Thread(function ()
    while (true) do
        onGuard.Wait(1000)

        TriggerServerEvent('onGuard:requestEvent')
    end
end)
