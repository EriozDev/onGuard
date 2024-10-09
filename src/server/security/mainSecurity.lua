if CFG.Active.GlobalAc then
    onGuard.OnNet('onGuard:detect:godMod', function()
        local src = source;
        local name = GetPlayerName(src);
        local ide = GetPlayerIdentifierByType(src, 'license');

        LOG.OnGuard('Player => ' ..
            name ..
            ' [' ..
            src ..
            '] (' .. ide .. ') Attempt to God Mod.')
        DropPlayer(src, 'Attempt to GodMod')
    end)

    onGuard.OnNet('onGuard:detect:invisible', function()
        local src = source;
        local name = GetPlayerName(src);
        local ide = GetPlayerIdentifierByType(src, 'license');

        LOG.OnGuard('Player => ' ..
            name ..
            ' [' ..
            src ..
            '] (' .. ide .. ') Attempt to InvisibleMod.')
        DropPlayer(src, 'Attempt to InvisibleMod')
    end)

    onGuard.OnNet('onGuard:detect:entitySpawn', function()
        local src = source;
        local name = GetPlayerName(src);
        local ide = GetPlayerIdentifierByType(src, 'license');

        LOG.OnGuard('Player => ' ..
            name ..
            ' [' .. src .. '] (' .. ide .. ') Attempt to spawn entity (vehicle).')
        DropPlayer(src, 'Attempt to spawn entity (vehicle)')
    end)

    onGuard.OnNet('onGuard:detect:entityRemove', function()
        local src = source;
        local name = GetPlayerName(src);
        local ide = GetPlayerIdentifierByType(src, 'license');

        LOG.OnGuard('Player => ' ..
            name ..
            ' [' ..
            src ..
            '] (' .. ide .. ') Attempt to Remove Entity.')
        DropPlayer(src, 'Attempt to Remove Entity')
    end)

    onGuard.OnNet('onGuard:detect:vehicleInvisible', function()
        local src = source;
        local name = GetPlayerName(src);
        local ide = GetPlayerIdentifierByType(src, 'license');

        LOG.OnGuard('Player => ' ..
            name ..
            ' [' ..
            src ..
            '] (' .. ide .. ') Attempt to InvisibleMod for vehicle.')
        DropPlayer(src, 'Attempt to InvisibleMod for vehicle')
    end)

    onGuard.OnNet('onGuard:detect:tazePlayer', function(id)
        local src = source;
        local name = GetPlayerName(src);
        local ide = GetPlayerIdentifierByType(src, 'license');

        LOG.OnGuard('Player => ' ..
            name ..
            ' [' ..
            src ..
            '] (' .. ide .. ') Attempt to Taze Player.')
        DropPlayer(id, 'Attempt to Taze Player')
    end)
    --
end
