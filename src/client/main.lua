PlayerLoaded = false

CreateThread(function()
    repeat Wait(1000) until NetworkIsSessionStarted()

    onGuard.TriggerServer('onGuard:PlayerJoin')
end)

onGuard.OnNet('client:init', function(id)
    --local client = Client.Init(id)
    Wait(15000)
    PlayerLoaded = true
end)
