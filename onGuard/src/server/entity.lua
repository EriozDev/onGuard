onGuard.Entity = {}

onGuard.OnNet('onGuard:state:init', function(key, value)
    if onGuard.Entity[key] ~= nil then
        LOG.Error('This State ' .. key .. ' Already exist')
        return
    end

    onGuard.Entity[key] = value
end)

onGuard.OnNet('onGuard:state:set', function(key, value)
    if onGuard.Entity[key] == nil then
        return
    end

    onGuard.Entity[key] = value
end)

function onGuard.Entity.State(k, v)
    onGuard.Entity[k] = v
    onGuard.TriggerClient('onGuard:state:init', k, v)
end

function onGuard.Entity.SetState(k, v)
    if onGuard.Entity[k] == nil then
        LOG.Error('This State is not valid then is not possible to set!')
    else
        onGuard.Entity[k] = v
        onGuard.TriggerClient('onGuard:state:set', k, v)
    end
end

function onGuard.Entity.GetState(k)
    return onGuard.Entity[k] ~= nil
end
