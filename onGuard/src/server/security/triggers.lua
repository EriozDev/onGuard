protectedEvent = {}

function onGuard.RegisterEvent(_eventName, _eventFunction)
    if _eventName == nil then
        return
    end

    protectedEvent[_eventName] = onGuard.generateToken()

    RegisterNetEvent(_eventName, function(token, ...)
        local src = source;
        local name = GetPlayerName(src);
        local ide = GetPlayerIdentifierByType(src, 'license');
        if token ~= protectedEvent[_eventName] then
            protectedEvent[_eventName] = onGuard.generateToken()
            LOG.OnGuard('Player => ' ..
                name ..
                ' [' ..
                src ..
                '] (' .. ide .. ') Attempt to execute trigger: ' .. _eventName)
            onGuard.TriggerClient('onGuard:syncEvent', protectedEvent)
            CancelEvent()
        else
            _eventFunction(...)
            protectedEvent[_eventName] = onGuard.generateToken()
            onGuard.TriggerClient('onGuard:syncEvent', protectedEvent)
        end
    end)
end

---@param _eventName string
function onGuard.GetTokenByEventName(_eventName)
    return protectedEvent[_eventName] ~= nil
end

onGuard.CreateThread(function()
    while (true) do
        onGuard.Wait(1000)

        onGuard.TriggerClient('onGuard:syncEvent', protectedEvent)
    end
end)
