---@class Client
Client = {}
Idx = 0

function Client.Init(clientId)
    local self = {};

    self.client = clientId;
    self.clientName = GetPlayerName(self.client);
    Idx = Idx + 1
    self.uniqueid = Idx;
    self.__ = {};

    LOG.Debug('Client was init successfully!')
    return (self);
end

---@param _e string
function Client:NetworkRegisterEvent(_e, _f)
    RegisterNetEvent(_e, function(clientId)
        if (clientId ~= self.client) then
            LOG.Error('Client.TriggerNetworkEvent clientId in event#args is not == id of client')
            return
        end

        _f()
    end)
end

function Client:getUserName()
    return (self.clientName);
end

function Client:setProperties(pr)
    self.__ = pr
end

function Client:getProperties()
    return self.__ or {};
end

function Client:setState(k, v)
    self.__[k] = v
end

function Client:getState(k)
    return self.__[k] ~= nil
end

function Client:getClientId()
    return (self.client);
end

function Client:setUniqueId(uid)
    self.uniqueid = uid;
end

function Client:getClientUniqueId()
    return (self.uniqueid);
end

function Client:destroy()
    table.wipe(self)
end
