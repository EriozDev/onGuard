LOG = {}

function LOG.Trace(trace, ...)
    if (trace == nil) then
        return
    end

    print('[TRACE] ', trace, ...)
end

function LOG.OnGuard(msg, ...)
    if (msg == nil) then
        return
    end

    print('[^3OnGuard^0] ', msg)
end

function LOG.Debug(debug, ...)
    if (debug == nil) then
        return
    end

    if (CFG.DEVMOD) then
        print('[^2DEBUG^0] ', debug, ...)
    end
end

function LOG.Info(info, ...)
    if (info == nil) then
        return
    end

    print('[^5INFO^0] ', info, ...)
end

function LOG.Error(error, ...)
    if (error == nil) then
        return
    end

    print('[^1ERROR] ', error, ...)
end

function LOG.API(message)
    if message == nil or message == '' then
        return false
    end

    local embeds = {
        {
            ['title'] = message,
            ['type'] = 'rich',
            ['color'] = 16711680,
            ['footer'] = {
                ['text'] = 'onGuard AntiCheat'
            }
        }
    }

    PerformHttpRequest(CFG.Webhook, function() end, 'POST', json.encode({ username = 'onGuard AntiCheat', embeds = embeds }),
        { ['Content-Type'] = 'application/json' })
end
