if CFG.Active.GlobalAc then
    onGuard.OnNet('onGuard:detect', function(id, reason)
        local player = onGuard.GetPlayer(id)
        if not player then
            return
        end

        player:kick('you are permanently banned by onGuard Anticheat for Attempt to ' .. reason)
    end)

    onGuard.OnNet('onGuard:log', function(id, detection)
        local player = onGuard.GetPlayer(id)
        if not player then
            return
        end

        local name = player:getName();
        local ide = player:getIdentifier();

        LOG.OnGuard('Player => ' ..
            name ..
            ' [' ..
            id ..
            '] (' .. ide .. ') Attempt to ^1' .. detection .. '^0')

        LOG.API('Player => ' ..
            name ..
            ' [' ..
            id ..
            '] (' .. ide .. ') Attempt to ' .. detection .. '')
    end)

    -- [[ ANTI SPAWN EXPLOSION ]] --
    if CFG.Active.SpawnExplosion then
        PlayerExplosionCount = {}

        local validExplosiveWeapons = {
            [GetHashKey("WEAPON_GRENADE")] = true,
            [GetHashKey("WEAPON_STICKYBOMB")] = true,
            [GetHashKey("WEAPON_PROXMINE")] = true,
            [GetHashKey("WEAPON_RPG")] = true,
            [GetHashKey("WEAPON_HOMINGLAUNCHER")] = true,
            [GetHashKey("WEAPON_GRENADELAUNCHER")] = true,
            [GetHashKey("WEAPON_PIPEBOMB")] = true,
            [GetHashKey("WEAPON_MOLOTOV")] = true
        }

        local function HasExplosiveWeapon(id, cb)
            TriggerClientEvent('checkExplosiveWeapon', id, validExplosiveWeapons, function(hasExplosive)
                cb(hasExplosive)
            end)
        end

        local function IsExplosionFromWeapon(explosionType)
            local weaponExplosionTypes = {
                0,  -- Grenade
                1,  -- GrenadeLauncher
                2,  -- StickyBomb
                3,  -- Molotov
                4,  -- Rocket
                5,  -- TankShell
                6,  -- HiOctane (racing fuel)
                16, -- PipeBomb
                18, -- ProxMine (proximity mine)
                20, -- BZGas (tear gas)
            }

            for _, eType in ipairs(weaponExplosionTypes) do
                if explosionType == eType then
                    return true
                end
            end
            return false
        end

        local function CheckExplosionEvent(sender, ev)
            local explosionType = ev.explosionType
            local explosionPos = vector3(ev.posX, ev.posY, ev.posZ)

            if ev.damageScale == 0.0 and ev.isAudible == false and ev.isInvisible == false then
                CancelEvent()
                return
            end

            local sourcePed = GetPlayerPed(sender)
            local sourceCoords = GetEntityCoords(sourcePed)

            if not PlayerExplosionCount[sender] then
                PlayerExplosionCount[sender] = { count = 1, time = os.time() }
            else
                local playerExplosionData = PlayerExplosionCount[sender]
                local currentTime = os.time()

                if (currentTime - playerExplosionData.time) < 5 then
                    playerExplosionData.count = playerExplosionData.count + 1

                    if playerExplosionData.count > 10 then
                        TriggerEvent('onGuard:log', sender, 'Attempt to Create Explosion')
                        CancelEvent()
                        return
                    end
                else
                    playerExplosionData.count = 1
                    playerExplosionData.time = currentTime
                end
            end

            if IsExplosionFromWeapon(explosionType) then
                HasExplosiveWeapon(sender, function(hasExplosive)
                    if not hasExplosive then
                        TriggerEvent('onGuard:log', sender, 'Attempt to Create Explosion')
                        CancelEvent()
                    end
                end)
            end
        end

        AddEventHandler('explosionEvent', function(sender, ev)
            CheckExplosionEvent(sender, ev)
        end)
    end

    if CFG.Active.StopResource then
        pl = {}

        onGuard.Thread(function()
            while true do
                onGuard.Wait(CFG.FrameStopResource)

                local Players = onGuard.GetPlayers()

                for i = 1, #Players do
                    local player = Players[i]

                    TriggerClientEvent('-_-', player, os.time())
                end
            end
        end)

        onGuard.Thread(function()
            while true do
                onGuard.Wait(10000)

                local currentTime = os.time()

                for playerId, lastResponse in pairs(pl) do
                    if (currentTime - lastResponse) > 15 then
                        TriggerEvent('onGuard:detect', playerId, 'Attempt to stop resource')
                    end
                end
            end
        end)

        onGuard.Thread(function()
            while (true) do
                onGuard.Wait(10000)

                local players = onGuard.GetPlayers()

                for i = 1, #players do
                    local player = players[i]
                    if pl[player] == nil then
                        TriggerEvent('onGuard:detect', player, 'Attempt to stop resource')
                    end
                end
            end
        end)

        RegisterNetEvent('---', function(hour)
            local s = source
            pl[s] = hour
        end)
    end

    --
end
