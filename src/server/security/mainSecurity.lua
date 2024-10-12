if CFG.Active.GlobalAc then
    onGuard.OnNet('onGuard:detect', function(id, reason)
        onGuard.KickPlayer(id, 'Attempt to ' .. reason)
    end)

    onGuard.OnNet('onGuard:log', function(detection)
        local src = source;
        local name = GetPlayerName(src);
        local ide = GetPlayerIdentifierByType(src, 'license');

        LOG.OnGuard('Player => ' ..
            name ..
            ' [' ..
            src ..
            '] (' .. ide .. ') ^1' .. detection .. '^0')
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

                if (currentTime - playerExplosionData.time) < 10 then
                    playerExplosionData.count = playerExplosionData.count + 1

                    if playerExplosionData.count > 5 then
                        TriggerEvent('onGuard:detect', sender, 'Attempt to Create Explosion')
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
                        TriggerEvent('onGuard:detect', sender, 'Attempt to Create Explosion')
                        CancelEvent()
                    end
                end)
            end
        end

        AddEventHandler('explosionEvent', function(sender, ev)
            CheckExplosionEvent(sender, ev)
        end)
    end

    --
end
