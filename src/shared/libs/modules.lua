-- Author: Erioz

Module = {}
local ModuleList = {}

local __instance = {
    __index = Module
}

---@param moduleName string
---@param author string
---@param version number
---@param description string
function Module.New(moduleName, author, version, description)

    local self = {}

    self.module = moduleName
    self.author = author
    self.description = description
    self.version = version
    self.isActive = true
    self.status = 'start'

    setmetatable(self, __instance)

    ModuleList[self.module] = self
    return self
end

---@param ModuleName string
function Module.ItsMe(ModuleName)
    local module = ModuleList[ModuleName]
    if not module then
        return
    end

    return module
end

function Module:start()
    if self.status == 'start' then
        return self
    end

    onGuard.Thread(function()
        while self.status == 'stop' do
            onGuard.Wait(10)
        end

        LOG.Info(('Module %s Started!'):format(self.moduleName))
    end)
end

function Module:stop()
    if self.status == 'stop' then
        return self
    end

    onGuard.Thread(function()
        while self.status == 'start' do
            onGuard.Wait(10)
        end

        LOG.Info(('Module %s Stopped!'):format(self.moduleName))
    end)
end

---@param new string
function Module:setAuthor(new)
    self.author = new
end

function Module:getAuthor()
    return self.author
end

---@param new string
function Module:setDescription(new)
    self.description = new
end

function Module:getDescription()
    return self.description
end

---@param new number
function Module:setVersion(new)
    self.version = new
end

function Module:getVersion()
    return self.version
end

function Module:IsActive()
    return self.isActive
end

---@param new boolean
function Module:setActive(new)
    if new ~= 'false' and new ~= 'true' then
        return
    end

    self.isActive = new
end

function Module:getStatus()
    return self.status
end

---@param new string
function Module:setStatus(new)
    if new ~= 'start' and new ~= 'stop' then
        return
    end

    self.status = new
end

---@param _eventName string
function Module:EmitServer(_eventName, ...)
    onGuard.TriggerServer(_eventName, ...)
end

if IsDuplicityVersion() then
    ---@param _eventName string
    ---@param target number
    function Module:EmitClient(_eventName, target, ...)
        onGuard.TriggerClient(_eventName, target, ...)
    end

    ---@param _eventName string
    ---@param target number
    ---@param timeInterval number
    function Module:EmitClient(_eventName, target, timeInterval, ...)
        onGuard.Wait(timeInterval)
        self:EmitClient(_eventName, target, ...)
    end
end

---@param timeInterval number
function Module:Wait(timeInterval)
    onGuard.Wait(timeInterval)
end
