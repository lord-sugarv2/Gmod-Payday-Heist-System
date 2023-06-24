
local function GetGuardType(NPCs)
    local percentage, total = math.Rand(0, 100), 0
    for _, data in ipairs(NPCs) do
        total = total + data.Chance
        if percentage <= total then
            return data.Class
        end
    end

    return nil
end

local function GetGuards()
    local guards = {}
    for _, GuardEnt in ipairs(RVault.ActiveHeist.Guards) do
        if not GuardEnt then continue end
        if not IsValid(GuardEnt) then continue end
        table.insert(guards, GuardEnt)
    end
    return guards
end

function RVault:SpawnGuards()
    local NPCList = list.Get("NPC")
    local data = RVault.Heists[RVault.ActiveHeist.Difficulty]

    for i = 1, math.random(data["GuardsToSpawn"].Min, data["GuardsToSpawn"].Max) do
        if #GetGuards() >= data["MaxGuards"] then break end

        local GuardClass = GetGuardType(RVault.Heists[RVault.ActiveHeist.Difficulty]["NPCs"])
        local NPCData = NPCList[GuardClass]

        local GuardEnt = ents.Create(NPCData.Class)
        GuardEnt:SetPos(RVault.GuardLocation[math.random(1, #RVault.GuardLocation)])
        GuardEnt:SetModel(NPCData.Model)
        GuardEnt:SetCurrentWeaponProficiency(data["GuardAccuracy"] - 1)
        for _, weaponClass in ipairs(NPCData.Weapons) do
            GuardEnt:Give(weaponClass)
        end
        GuardEnt:Spawn()
        GuardEnt.RVault = true
        GuardEnt:SetMaxHealth(RVault.BaseHealth * data["GuardHealth"])
        GuardEnt:SetHealth(RVault.BaseHealth * data["GuardHealth"])

        table.insert(RVault.ActiveHeist.Guards, GuardEnt)
    end

    timer.Create("RVault:GuardTimer", math.random(RVault.SpawnRate[1], RVault.SpawnRate[2]) * data["SpawnRate"], 1, function()
        if not RVault.ActiveHeist then return end
        RVault:SpawnGuards()
    end)
end

function RVault:RemoveGuards()
    for k, v in ipairs(RVault.ActiveHeist and RVault.ActiveHeist.Guards or {}) do
        if not IsValid(v) then continue end
        v:Remove()
    end
end

hook.Add("OnNPCKilled", "RVault:DropMoney", function(npc, ply, wep)
    if not RVault.NPCDropMoney then return end

    local money = ents.Create("lords_money")
    money:SetPos(npc:GetPos() + Vector(0, 0, 2))
    money:Spawn()
    money.value = RVault.Heists[RVault.ActiveHeist.Difficulty]["GuardMoney"]
end)

hook.Add("EntityTakeDamage", "RVault:StopNPCDamage", function(ent, dmginfo)
    if ent.RVault and dmginfo:GetAttacker().RVault then return true end -- block them killing each other

    if not ent.RVault then return end
    local multiplier = 1 + (RVault.DamageMultiplier * RVault.Heists[RVault.ActiveHeist.Difficulty]["GuardDamage"])
    dmginfo:SetDamage(dmginfo:GetDamage() * multiplier)
end)