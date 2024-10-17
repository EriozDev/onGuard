protectedEvent = {}

function onGuard.RegisterEvent(_eventName, _eventFunction)
    if _eventName == nil then
        return
    end

    protectedEvent[_eventName] = onGuard.generateToken()

    RegisterNetEvent(_eventName, function(token, ...)
        local src = source;
        local player = onGuard.GetPlayer(src)
        if not player then
            return
        end


        local name = player:getName();
        local ide = player:getIdentifier();
        if token ~= protectedEvent[_eventName] then
            protectedEvent[_eventName] = onGuard.generateToken()
            LOG.OnGuard('Player => ' ..
                name ..
                ' [' ..
                src ..
                '] (' .. ide .. ') Attempt to execute trigger: ' .. _eventName)
            player:kick('Attempt to execute trigger: ' .. _eventName)
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

onGuard.OnNet('onGuard:requestEvent', function()
    local src = source;
    TriggerClientEvent('onGuard:syncEvent', src, protectedEvent)
end)
