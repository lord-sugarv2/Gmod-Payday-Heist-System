function RVault:OpenVault()
    if not RVault.ActiveHeist then return end

    local door = DarkRP.doorIndexToEnt(RVault.VaultDoorID)
    if not IsValid(door) then return end
    door:Fire("Unlock")
    door:Fire("Open")

    door.Opened = true

    RVault.ActiveHeist.VaultOpened = true
    hook.Run("RVault:VaultOpened")
end

function RVault:LockVault()
    local door = DarkRP.doorIndexToEnt(RVault.VaultDoorID)
    if not IsValid(door) then return end
    door.Opened = false
    door:Fire("Close")
    door:keysLock()

    door:setKeysNonOwnable(true)

    if RVault.ActiveHeist then
        RVault.ActiveHeist.VaultOpened = false
    end
    hook.Run("RVault:VaultClosed")
end

function RVault:RemoveDrill()
    local door = DarkRP.doorIndexToEnt(RVault.VaultDoorID)
    if not IsValid(door) then return end

    if IsValid(door.Drill) then
        door.Drill:Remove()
    end

    door.Drill = nil
end

function RVault:GetLoot()
    local tbl = {}
    for ent, exists in pairs(RVault.ActiveHeist.Loot) do
        if not ent or not IsValid(ent) then continue end
        if not exists then continue end
        table.insert(tbl, ent)
    end
    return tbl
end

function RVault:SpawnLoot()
    for _, v in ipairs(RVault.Loot) do
        if math.random(1, 100) > v.SpawnChance then continue end
        local ent = ents.Create(v.Ent)
        ent:Spawn()
        ent:SetPos(v.SpawnPos)
        ent.HeistLoot = true
        RVault.ActiveHeist.Loot[ent] = true
    end
end

function RVault:RemoveLoot()
    if not RVault.ActiveHeist then return end
    for ent, _ in pairs(RVault.ActiveHeist.Loot) do
        if not IsValid(ent) then continue end
        ent:Remove()
    end
end

hook.Add("canLockpick", "RVault:StopVaultLockpick", function(ply, ent)
    if ent:isDoor() and ent:doorIndex() == RVault.VaultDoorID then
        return false
    end
end)

hook.Add("InitPostEntity", "RVault:InitVault", function()
    RVault:LockVault()
end)

hook.Add("RVault:VaultOpened", "RVault:SpawnLoot", function()
    RVault:SpawnLoot()
end)

hook.Add("RVault:VaultClosed", "RVault:RemoveLoot", function()
    RVault:RemoveLoot()
end)