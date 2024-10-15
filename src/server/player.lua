player = {}
PlayerManager = {}

local __instance = {
    __index = player
}

---@class player
function player.Init(id)

    local self = setmetatable({}, __instance)

    self.name = GetPlayerName(id)
    self.identifier = GetPlayerIdentifierByType(id, 'license')
    self.source = id
    self.CheatDoubts = 0

    return self
end

function player:getSource()
    return self.source
end

function player:getName()
    return self.name
end

function player:getIdentifier()
    return self.identifier
end

function player:getDoubts()
    return self.CheatDoubts
end

---@param n number
function player:addDoubts(n)
    self.CheatDoubts = self.CheatDoubts + 1
end

---@param n number
function player:removeDoubts(n)
    self.CheatDoubts = self.CheatDoubts - 1
end

---@param n number
function player:setDoubts(n)
    self.CheatDoubts = n
end

function player:clearDoubts()
    self.CheatDoubts = 0
end

---@param reason string
function player:kick(reason)
    DropPlayer(self.source, reason)
end

---@class PlayerManager
function PlayerManager.AddPlayer(id)
    PlayerInGame[id] = player.Init(id)
end

function PlayerManager.RemovePlayer(id)
    if not PlayerInGame[id] then
        return
    end

    PlayerInGame[id] = nil
end

function onGuard.GetPlayer(id)
    return PlayerInGame[id]
end
