local PlayerLoaded = false

CreateThread(function()
    repeat Wait(1000) until NetworkIsSessionStarted()
    PlayerLoaded = true

    onGuard.TriggerServer('onGuard:PlayerJoin')
end)

onGuard.OnNet('client:init', function(id)
    local client = Client.Init(id)
end)
