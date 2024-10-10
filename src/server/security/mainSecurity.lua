if CFG.Active.GlobalAc then
    onGuard.OnNet('onGuard:detect', function(reason)
        local src = source;
        local name = GetPlayerName(src);
        local ide = GetPlayerIdentifierByType(src, 'license');

        LOG.OnGuard('Player => ' ..
            name ..
            ' [' ..
            src ..
            '] (' .. ide .. ') Attempt to ' .. reason)
        onGuard.KickPlayer(src, 'Attempt to ' .. reason)
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
        onGuard.KickPlayer(id, 'Attempt to Taze Player')
    end)
    --
end
