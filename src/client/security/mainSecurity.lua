-- [[ ANTI GOD MOD ]] --

if CFG.Active.GlobalAc then
    if CFG.Active.GodMod then
        onGuard.Thread(function()
            while (true) do
                onGuard.Wait(CFG.FrameGodMod)

                if not PlayerLoaded then goto skip end

                local plyPed = PlayerPedId()
                local player = PlayerId()

                if NetworkIsLocalPlayerInvincible() or GetPlayerInvincible(player) or GetEntityHealth(plyPed) > 200 then
                    onGuard.TriggerServer('onGuard:detect', 'GodMod')
                else
                    if not IsPlayerDead(player) then
                        if GetEntityHealth(plyPed) > 2 then
                            local plyHealth = GetEntityHealth(plyPed)
                            ApplyDamageToPed(plyPed, 2, false)
                            onGuard.Wait(25)

                            if GetEntityHealth(plyPed) == plyHealth then
                                onGuard.TriggerServer('onGuard:detect', 'GodMod')
                            else
                                SetEntityHealth(plyPed, plyHealth)
                            end
                        end

                        if GetPedArmour(plyPed) > 2 then
                            local plyArmor = GetPedArmour(plyPed)
                            ApplyDamageToPed(plyPed, 2, true)
                            Citizen.Wait(25)

                            if GetPedArmour(plyPed) == plyArmor then
                                onGuard.TriggerServer('onGuard:detect', 'GodMod')
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
                    onGuard.TriggerServer('onGuard:detect', 'Invisible')
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
                    onGuard.TriggerServer('onGuard:detect', 'Invisible Vehicle')
                end


                :: skip ::
            end
        end)
    end

    -- [[ ANTI SPAWN ENTITY ]] --
    if CFG.Active.SpawnEntity then
        local registeredVehicles = {}
        local VehicleId = 0

        function CreateSafeVehicle(model, x, y, z, heading, owner)
            local hash = GetHashKey(model)

            if not HasModelLoaded(hash) then
                RequestModel(hash)
                while not HasModelLoaded(hash) do
                    Citizen.Wait(0)
                end
            end

            local vehicle = CreateVehicle(hash, x, y, z, heading, true, false)

            VehicleId = VehicleId + 1
            registeredVehicles[VehicleId] = { veh = vehicle, owner = owner }

            SetVehicleHasBeenOwnedByPlayer(vehicle, true)

            return vehicle
        end

        CreateVehicle = CreateSafeVehicle

        function GetSafeVehicleId(vehicle)
            for id, data in pairs(registeredVehicles) do
                if data.veh == vehicle then
                    return id
                end
            end
            return nil
        end

        function GetVehiclesInArea(pos, radius)
            local vehiclesInRange = {}
            local vehicles = GetGamePool('CVehicle')

            for _, vehicle in ipairs(vehicles) do
                local vehPos = GetEntityCoords(vehicle)
                local distance = #(pos - vehPos)

                if distance <= radius then
                    table.insert(vehiclesInRange, vehicle)
                end
            end

            return vehiclesInRange
        end

        --Citizen.CreateThread(function()
        --    while true do
        --        Citizen.Wait(5000)
        --
        --        local playerPed = PlayerPedId()
        --        local playerPos = GetEntityCoords(playerPed)
        --
        --        local vehicles = GetVehiclesInArea(playerPos, 20.0)
        --
        --        for _, vehicle in ipairs(vehicles) do
        --            local owner = NetworkGetEntityOwner(vehicle)
        --
        --            if owner == PlayerId() then
        --                local vehicleId = GetSafeVehicleId(vehicle)
        --
        --                if not vehicleId then
        --                    onGuard.TriggerServer('onGuard:detect', 'Spawn Entity (vehicle)')
        --                    DeleteEntity(vehicle)
        --                end
        --            end
        --        end
        --    end
        --end)
    end

    -- [[ ANTI REMOVE ENTITY ]] --
    if CFG.Active.RemoveEntity then
        function DeleteSafeVehicle(entity)
            local entityId = GetSafeVehicleId(entity)
            if entityId == nil then
                DeleteEntity(entity)
            end

            local owner = NetworkGetEntityOwner(entity)
            if owner ~= GetPlayerServerId(PlayerId()) then
                onGuard.TriggerServer('onGuard:detect', 'Remove Entity')
            end
        end
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

                    if HasPedGotWeapon(attackerPed, tazerWeaponHash, false) then
                        if isDistanceLegit(attackerPed, victimPed) then
                        else
                            onGuard.TriggerServer('onGuard:detect:tazePlayer', GetPlayerServerId(attacker))
                            CancelEvent()
                        end
                    else
                        onGuard.TriggerServer('onGuard:detect:tazePlayer', GetPlayerServerId(attacker))
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
                if GetDistanceBetweenCoords(posx, posy, posz, newx, newy, newz) > 50 and still == IsPedStill(ped) and vel == GetEntitySpeed(ped) and not IsPedInParachuteFreeFall(ped) and not IsPedJumpingOutOfVehicle(ped) and ped == newPed then
                    --TODO TWEAKS FOR TP FROM STAFF
                    if not IsPedInVehicle(newPed) and not IsPedFalling(newPed) and not IsPedJumping(newPed) then
                        onGuard.TriggerServer('onGuard:detect', 'NoClip')
                    end
                end

                :: skip ::
            end
        end)

        Citizen.CreateThread(function()
            while (true) do
                Citizen.Wait(CFG.Frame)

                if not PlayerLoaded then goto skip end

                local ped = PlayerPedId()
                if DoesEntityExist(ped) and not IsPedInAnyVehicle(ped, false) then
                    local pos = GetEntityCoords(ped)
                    local groundZ = GetGroundZFor_3dCoord(pos.x, pos.y, pos.z, false)

                    if pos.z - groundZ > 10.0 then
                        --TODO CHECK FALSE WITH TERA FORMING
                        onGuard.TriggerServer('onGuard:detect', 'NoClip')
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
                    onGuard.TriggerServer('onGuard:detect', 'NoClip')
                end
            end
        end)
    end

end
