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

function onGuard.Entity.GetState(k)
    return onGuard.Entity[k] ~= nil
end
