eventManager = {}
InterneEvent = {}
Idx = 0

local __instance = {
    index = eventManager
}

function eventManager.New(eventName, eventFunction)
    RegisterNetEvent(eventName, eventFunction)

    local self = setmetatable({}, __instance)

    self.event = eventName
    Idx = Idx + 1
    self.eventUniqueId = Idx

    InterneEvent[eventName] = self
    return
end

function eventManager:on(eventFunction)
    AddEventHandler(self.event, function()
        eventFunction(...)
    end)
end
