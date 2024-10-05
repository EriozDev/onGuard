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
                    onGuard.TriggerServer('onGuard:detect:godMod')
                else
                    if not IsPlayerDead(player) then
                        if GetEntityHealth(plyPed) > 2 then
                            local plyHealth = GetEntityHealth(plyPed)
                            ApplyDamageToPed(plyPed, 2, false)
                            onGuard.Wait(25)

                            if GetEntityHealth(plyPed) == plyHealth then
                                onGuard.TriggerServer('onGuard:detect:godMod')
                            else
                                SetEntityHealth(plyPed, plyHealth)
                            end
                        end

                        if GetPedArmour(plyPed) > 2 then
                            local plyArmor = GetPedArmour(plyPed)
                            ApplyDamageToPed(plyPed, 2, true)
                            Citizen.Wait(25)

                            if GetPedArmour(plyPed) == plyArmor then
                                onGuard.TriggerServer('onGuard:detect:godMod')
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
                    onGuard.TriggerServer('onGuard:detect:invisible')
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

                if GetEntityAlpha(vehicle) == 0 or not IsEntityVisible(vehicle) then
                    onGuard.TriggerServer('onGuard:detect:vehicleInvisible')
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

        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(5000)

                local playerPed = PlayerPedId()
                local playerPos = GetEntityCoords(playerPed)

                local vehicles = GetVehiclesInArea(playerPos, 20.0)

                for _, vehicle in ipairs(vehicles) do
                    local owner = NetworkGetEntityOwner(vehicle)

                    if owner == PlayerId() then
                        local vehicleId = GetSafeVehicleId(vehicle)

                        if not vehicleId then
                            onGuard.TriggerServer('onGuard:detect:entitySpawn')
                            DeleteEntity(vehicle)
                        end
                    end
                end
            end
        end)
    end

    if CFG.Active.RemoveEntity then
        function DeleteSafeVehicle(entity)
            local entityId = GetSafeVehicleId(entity)
            if entityId == nil then
                DeleteEntity(entity)
            end

            local owner = NetworkGetEntityOwner(entity)
            if owner ~= GetPlayerServerId(PlayerId()) then
                onGuard.TriggerServer('onGuard:detect:entityRemove')
            end
        end
    end
end
