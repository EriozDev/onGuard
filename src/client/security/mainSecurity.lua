if CFG.Active.GlobalAc then
    -- [[ ANTI SPAWN VEHICLE BY SERVER ]] --
    if CFG.Active.BlacklistVehicle then
        onGuard.Thread(function()
            for _, vehicle in pairs(CFG.BlacklistVehicle) do
                local hash = GetHashKey(vehicle)
                SetVehicleModelIsSuppressed(hash, true)
            end

            while (true) do
                onGuard.Wait(CFG.Frame)
            end
        end)

        onGuard.Thread(function()
            while (true) do
                onGuard.Wait(CFG.Frame)

                local playerPed = PlayerPedId()
                local vehicle = GetVehiclePedIsIn(playerPed, false)

                if vehicle == 0 then goto skip end
                local hash = GetEntityModel(vehicle)
                local vehicleName = GetDisplayNameFromVehicleModel(hash)

                for _, blockedVehicle in pairs(CFG.BlacklistVehicle) do
                    if vehicleName == blockedVehicle then
                        DeleteEntity(vehicle)
                        onGuard.TriggerServer('onGuard:log', GetPlayerServerId(PlayerId()), 'Blacklist Vehicle => ' .. vehicleName)
                    end
                end

                :: skip ::
            end
        end)
    end

    -- [[ ANTI GOD MOD ]] --
    if CFG.Active.GodMod then
        onGuard.Thread(function()
            while (true) do
                onGuard.Wait(CFG.FrameGodMod)

                if not PlayerLoaded then goto skip end

                local plyPed = PlayerPedId()
                local player = PlayerId()

                if NetworkIsLocalPlayerInvincible() or GetPlayerInvincible(player) or GetEntityHealth(plyPed) > 200 then
                    onGuard.TriggerServer('onGuard:detect', GetPlayerServerId(PlayerId()), 'GodMod')
                else
                    if not IsPlayerDead(player) then
                        if GetEntityHealth(plyPed) > 2 then
                            local plyHealth = GetEntityHealth(plyPed)
                            ApplyDamageToPed(plyPed, 2, false)
                            onGuard.Wait(25)

                            if GetEntityHealth(plyPed) == plyHealth then
                                onGuard.TriggerServer('onGuard:detect', GetPlayerServerId(PlayerId()), 'GodMod')
                            else
                                SetEntityHealth(plyPed, plyHealth)
                            end
                        end

                        if GetPedArmour(plyPed) > 2 then
                            local plyArmor = GetPedArmour(plyPed)
                            ApplyDamageToPed(plyPed, 2, true)
                            Citizen.Wait(25)

                            if GetPedArmour(plyPed) == plyArmor then
                                onGuard.TriggerServer('onGuard:detect', GetPlayerServerId(PlayerId()), 'GodMod')
                            else
                                SetPedArmour(plyPed, plyArmor)
                            end
                        end
                    end
                end

                :: skip ::
            end
        end)
    end

    -- [[ ANTI INVISIBLE ]] --
    if CFG.Active.Invisible then
        onGuard.Thread(function()
            while (true) do
                onGuard.Wait(CFG.Frame)

                if not PlayerLoaded then goto skip end

                local PlayerPedId = PlayerPedId()

                if GetEntityAlpha(PlayerPedId) == 0 or not IsEntityVisible(PlayerPedId) then
                    onGuard.TriggerServer('onGuard:detect', GetPlayerServerId(PlayerId()), 'Invisible')
                end

                :: skip ::
            end
        end)
    end

    -- [[ ANTI INVISIBLE VEHICLE ]] --
    if CFG.Active.VehicleInvisible then
        onGuard.Thread(function()
            while (true) do
                onGuard.Wait(CFG.Frame)

                if not PlayerLoaded then goto skip end

                local PlayerPedId = PlayerPedId()
                local vehicle = GetVehiclePedIsIn(PlayerPedId, false)

                if vehicle == 0 then goto skip end

                if GetEntityAlpha(vehicle) == 0 or not IsEntityVisible(vehicle) then
                    onGuard.TriggerServer('onGuard:detect', GetPlayerServerId(PlayerId()), 'Invisible Vehicle')
                end

                :: skip ::
            end
        end)
    end

    -- [[ ANTI TAZE PLAYER ]] --
    if CFG.Active.TazePlayer then
        local tazerWeaponHash = GetHashKey('WEAPON_STUNGUN')

        function isTazer(weaponHash)
            return weaponHash == tazerWeaponHash
        end

        function isDistanceLegit(attackerPed, victimPed)
            local attackerPos = GetEntityCoords(attackerPed)
            local victimPos = GetEntityCoords(victimPed)
            local distance = #(attackerPos - victimPos)

            return distance <= 10
        end

        AddEventHandler('gameEventTriggered', function(eventName, eventData)
            if eventName == 'CEventNetworkEntityDamage' then
                local attacker = eventData[1]
                local victim = eventData[2]
                local weaponHash = eventData[7]

                if isTazer(weaponHash) then
                    local attackerPed = GetPlayerPed(attacker)
                    local victimPed = GetPlayerPed(victim)
                    local tazerWeaponHash = GetHashKey('WEAPON_STUNGUN')


                    if HasPedGotWeapon(attackerPed, tazerWeaponHash, false) then
                        if isDistanceLegit(attackerPed, victimPed) then
                        else
                            onGuard.TriggerServer('onGuard:detect', GetPlayerServerId(attacker), 'Attempt to Taze Player')
                            CancelEvent()
                        end
                    else
                        onGuard.TriggerServer('onGuard:detect', GetPlayerServerId(attacker), 'Attempt to Taze Player')
                        CancelEvent()
                    end
                end
            end
        end)
    end

    -- [[ ANTI NOCLIP ]] --
    if CFG.Active.NoClip then
        onGuard.Thread(function()
            while (true) do
                onGuard.Wait(CFG.Frame)

                if not PlayerLoaded then goto skip end

                local ped = PlayerPedId()
                local posx, posy, posz = table.unpack(GetEntityCoords(ped, true))
                local still = IsPedStill(ped)
                local vel = GetEntitySpeed(ped)
                Citizen.Wait(2800)

                local newx, newy, newz = table.unpack(GetEntityCoords(ped, true))
                local newPed = PlayerPedId()
                if GetDistanceBetweenCoords(posx, posy, posz, newx, newy, newz) > 20 and still == IsPedStill(ped) and vel == GetEntitySpeed(ped) and not IsPedInParachuteFreeFall(ped) and not IsPedJumpingOutOfVehicle(ped) and ped == newPed then
                    if not IsPedInVehicle(newPed) and not IsPedFalling(newPed) and not IsPedJumping(newPed) then
                        onGuard.TriggerServer('onGuard:detect', GetPlayerServerId(PlayerId()), 'NoClip')
                    end
                end

                :: skip ::
            end
        end)

        local playerSpawnTime = nil

        AddEventHandler('playerSpawned', function()
            playerSpawnTime = GetGameTimer()
        end)

        local function isPlayerClipping()
            if not playerSpawnTime then return false end

            local currentTime = GetGameTimer()

            if (currentTime - playerSpawnTime) < 30000 then
                return false
            end

            local ped = PlayerPedId()
            local startPos = GetEntityCoords(ped)
            local endPos = startPos + vector3(0, 0, -10)

            local rayHandle = StartShapeTestRay(startPos, endPos, 1, ped, 7)
            local _, hit, hitCoords, _, entity = GetShapeTestResult(rayHandle)

            if hit == 0 then
                return true
            end

            return false
        end

        onGuard.Thread(function()
            while (true) do
                onGuard.Wait(CFG.Frame)

                if isPlayerClipping() then
                    onGuard.TriggerServer('onGuard:detect', GetPlayerServerId(PlayerId()), 'NoClip')
                end
            end
        end)
    end

    -- [[ ANTI FREE CAM ]] --
    if CFG.Active.FreeCam then
        onGuard.Thread(function()
            while (true) do
                onGuard.Wait(CFG.Frame)

                if not PlayerLoaded then goto skip end

                if #(GetFinalRenderedCamCoord() - GetEntityCoords(PlayerPedId())) > 100 then
                    onGuard.TriggerServer("onGuard:detect", GetPlayerServerId(PlayerId()), 'FreeCam')
                end

                :: skip ::
            end
        end)
    end

    -- [[ ANTI PLATE CHANGER ]] --
    if CFG.Active.PlateChanger then
        statePlate = {}

        function initStatePlate(vehicle)
            local plate = GetVehicleNumberPlateText(vehicle)
            statePlate[vehicle] = plate
        end

        function CheckPlate(vehicle)
            local currentPlate = GetVehicleNumberPlateText(vehicle)
            local initialPlate = statePlate[vehicle]

            if currentPlate ~= initialPlate then
                onGuard.TriggerServer('onGuard:log', GetPlayerServerId(PlayerId()),
                    ' Possible Plate Change. oldPlate: ' ..
                    initialPlate ..
                    ' => new: ' .. currentPlate .. ' onGuard has replaced to old: ' .. initialPlate)
                SetVehicleNumberPlateText(vehicle, initialPlate)
            end
        end

        onGuard.Thread(function()
            while (true) do
                onGuard.Wait(CFG.Frame)

                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

                if vehicle == 0 then goto skip end

                if GetPedInVehicleSeat(vehicle, -1) ~= PlayerPedId() then goto skip end

                if not statePlate[vehicle] then
                    initStatePlate(vehicle)
                else
                    CheckPlate(vehicle)
                end

                :: skip ::
            end
        end)
    end

    RegisterNetEvent('onGuard:getExplosiveWeapon')
    AddEventHandler('onGuard:getExplosiveWeapon', function(validExplosiveWeapons, cb)
        local playerPed = PlayerPedId()

        for _, weaponName in ipairs(validExplosiveWeapons) do
            local weaponHash = GetHashKey(weaponName)
            if HasPedGotWeapon(playerPed, weaponHash, false) then
                cb(true)
                return
            end
        end

        cb(false)
    end)

    RegisterNetEvent('-_-')
    AddEventHandler('-_-', function(hour)
        TriggerServerEvent('---', hour)
    end)

    -- [[ ANTI SUPER JUMP ]] --
    if CFG.Active.SuperJump then
        local superJumpThreshold = 3.0

        function IsPlayerUsingSuperJump()
            local ped = GetPlayerPed(-1)
            local _, _, z1 = table.unpack(GetEntityCoords(ped, true))
            Wait(200)
            local _, _, z2 = table.unpack(GetEntityCoords(ped, true))

            local heightDifference = z2 - z1

            return heightDifference > superJumpThreshold
        end

        onGuard.Thread(function()
            while (true) do
                onGuard.Wait(500)

                if GetVehiclePedIsIn(PlayerPedId(), false) ~= 0 then goto skip end

                if IsPedJumping(PlayerPedId()) then
                    if IsPlayerUsingSuperJump() then
                        onGuard.TriggerServer('onGuard:log', GetPlayerServerId(PlayerId()), 'SuperJump')
                    end
                end

                :: skip ::
            end
        end)
    end

    -- [[ ANTI FAST RUN ]] --
    if CFG.Active.FastRun then
        onGuard.Thread(function()
            while (true) do
                onGuard.Wait(CFG.Frame)

                if GetVehiclePedIsIn(PlayerPedId()) ~= 0 then goto skip end

                if IsPedRunning(PlayerPedId()) then
                    if GetEntitySpeed(PlayerPedId()) > 8.0 then
                        onGuard.TriggerServer('onGuard:detect', GetPlayerServerId(PlayerId()), 'Fast Run')
                    end
                end

                :: skip ::
            end
        end)
    end

end
