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
    end)

    onGuard.OnNet('onGuard:detect:entitySpawn', function()
        local id = source
        local ownerLicense = GetPlayerIdentifierByType(id, 'license')

        LOG.OnGuard('Player => ' ..
            GetPlayerName(id) ..
            ' [' .. id .. '] (' .. ownerLicense .. ') Attempt to spawn entity (vehicle).')
    end)
    --
end
