PlayerInGame = {}

RegisterNetEvent('onGuard:PlayerLoaded', function(_id)
    LOG.Info('Player Joined! ', _id)
    onGuard.TriggerClient('client:init', _id)
end)

RegisterNetEvent('onGuard:PlayerJoin', function()
    local src = source

    PlayerInGame[src] = true
    LOG.Info('Player Joining...')
    TriggerEvent('onGuard:PlayerLoaded', src)
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    if (PlayerInGame[src]) then
        PlayerInGame[src] = nil
        LOG.Info('Player Dropped! ', src)
    end
end)

onGuard.Thread(function()
    for i = 1, GetNumResources() do
        local resourceName = GetResourceByFindIndex(i)

        if resourceName ~= nil then
            onGuard.Wait(200)
            LOG.OnGuard(('=> Protect resource ^4%s^0'):format(resourceName))
        end
    end

    LOG.OnGuard(('^1OnGuard - Anticheat^3 protects the server!^0'):format(resourceName))
end)

for i = 1, GetNumResources() do
    local resourceName = GetResourceByFindIndex(i)

    if resourceName ~= nil then
        local nomFichier = "fxmanifest.lua"
        local chemin = ("%s/%s"):format(GetResourcePath(resourceName), nomFichier)

        local fichier = io.open(chemin, "r")

        if fichier then
            local content = fichier:read("*all")
            fichier:close()

            local serverLine = "@onGuard/src/server/functions.lua"

            local serverAdded = false

            if not string.find(content, serverLine, 1, true) then
                content = content:gsub("(server_scripts%s*{)", "%1\n    '" .. serverLine .. "',")
                serverAdded = true
            end

            if serverAdded then
                fichier = io.open(chemin, "w")
                if fichier then
                    fichier:write(content)
                    fichier:close()
                else
                    print("Failed to open file for writing: " .. chemin)
                end
            end
        else
            print("Failed to open file for reading: " .. chemin)
        end
    end
end
