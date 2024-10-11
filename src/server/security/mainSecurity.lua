if CFG.Active.GlobalAc then
    onGuard.OnNet('onGuard:detect', function(reason)
        local src = source;

        onGuard.KickPlayer(src, 'Attempt to ' .. reason)
    end)

    onGuard.OnNet('onGuard:detect:tazePlayer', function(id)
        local src = source;

        onGuard.KickPlayer(id, 'Attempt to Taze Player')
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
    --
end
