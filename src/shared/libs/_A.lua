_AC = {}

_AC.Errors = {
    ['Sync'] = 'Vous avez été déconnecter par onGuard Anticheat pour potentiellement cheat ou désynchronisation.',
    ['onGuard'] = 'onGuard.Error; onGuard need to restart'
}

function _A(key)
    if key == nil then
        return _AC
    end

    return _AC[key]
end

function Set_A(key, value)
    if key == nil or value == nil then
        return _AC.Errors['onGuard']
    end

    _AC[key] = value
end
