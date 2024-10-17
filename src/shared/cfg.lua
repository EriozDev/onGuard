CFG = {}
CFG.DEVMOD = true -- Don't tuch

-- [[ DETECTIONS ]] --
CFG.Active = {
    GlobalAc = true,
    BlacklistVehicle = true,
    BlacklistPed = true,
    GodMod = true,
    NoClip = true,
    FreeCam = true,
    Invisible = true,
    VehicleInvisible = true,
    AntiTriggersEvent = true,
    TazePlayer = true,
    PlateChanger = true,
    SpawnExplosion = true,
    StopResource = true,
    SuperJump = true,
    FastRun = true
}

CFG.Webhook =
'https://discord.com/api/webhooks/1295767886056652820/tjFhow7_biVeF5xQP69HPGM25IIKYqq-e39S0IgX3KPVJeUqdaXD1AxKSInVKsmFsolt'

CFG.Frame = 1000
CFG.FrameGodMod = 60000
CFG.FrameStopResource = 3000

CFG.BlacklistVehicle = {     -- ALL MAJ FOR MODEL
    -- 'HYDRA'
}

CFG.BlacklistPed = {
    ['a_c_chimp'] = true,
    ['a_c_pig'] = true,
}