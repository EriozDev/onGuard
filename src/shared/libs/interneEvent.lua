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

function eventManager:hooks()
    local __ = {
        ['refreshAllEvent'] = function()
            local eventCount = 0
            for i = 1, #InterneEvent do
                local event = InterneEvent[i]
                local t = {}
                eventCount = eventCount + 1
                t[event] = eventCount
                if #t <= 0 then
                    return
                end

                RegisterNetEvent(event, function()
                end)
            end
        end
    }
end
