-- NPC From https://steamcommunity.com/sharedfiles/filedetails/?id=579592077
list.Set("NPC", "npc_rvault_tanker", {
    Name = "Tanker", 
    Class = "npc_combine_s",
    Model = "models/mark2580/payday2/pd2_bulldozer_combine.mdl",
    Weapons = {"m9k_acr"},
    Health = 100,
    KeyValues = {
        SquadName = "RVaultNPCs",
        Numgrenades = 5
    },
    Category = "RVault"
})

RVault = RVault or {}
RVault.Criminals = {
    ["Citizen"] = true,
}

RVault.Options = {
    {ID = "MoneyReward", NiceName = "Money Reward"},
    {ID = "GuardHealth", NiceName = "Guard Health"},
    {ID = "GuardDamage", NiceName = "Guard Damage"},
    {ID = "SpawnRate", NiceName = "Spawn Rate"},
    {ID = "GuardAccuracy", NiceName = "Guard Accuracy"},
    {ID = "Time", NiceName = "Time To Complete", Col = XeninUI.Theme.Red},
}

RVault.Upgrades = {
    {ID = "DrillBreak", Text = "• Wont notify you if the drill breaks"},
    {ID = "MaybeMoneyLoss", Text = "• 20% chance to loose 20% of your money if you die"},
    {ID = "LoseMoney", Text = "• You will lose 20% of your money if you die"},
}

RVault.Loot = {
    {SpawnPos = Vector(-3950.312744, -1989.688477, -187.687546), Ent = "lords_money_stack_big", SpawnChance = 100, Value = {Min = 10000, Max = 20000}},
    {SpawnPos = Vector(-3957.346436, -2027.006226, -152.840256), Ent = "lords_money_stack_big", SpawnChance = 100, Value = {Min = 10000, Max = 20000}},
    {SpawnPos = Vector(-3855.705811, -2001.036377, -187.895691), Ent = "lords_money_stack_big", SpawnChance = 100, Value = {Min = 10000, Max = 20000}},
    {SpawnPos = Vector(-3992.419922, -2096.496094, -187.661118), Ent = "lords_money_stack_big", SpawnChance = 100, Value = {Min = 10000, Max = 20000}},
    {SpawnPos = Vector(-3941.693359, -1581.823120, -187.419754), Ent = "lords_money_stack_big", SpawnChance = 100, Value = {Min = 10000, Max = 20000}},
    {SpawnPos = Vector(-4055.886963, -1545.017578, -187.582626), Ent = "lords_money_stack_big", SpawnChance = 100, Value = {Min = 10000, Max = 20000}},
    {SpawnPos = Vector(-4251.974121, -1584.027710, -187.901672), Ent = "lords_money_stack_big", SpawnChance = 100, Value = {Min = 10000, Max = 20000}},
    {SpawnPos = Vector(-4316.274414, -1706.680298, -187.283569), Ent = "lords_money_stack_big", SpawnChance = 100, Value = {Min = 10000, Max = 20000}},

    {SpawnPos = Vector(-4414.383301, -2125.988770, -149.783386), Ent = "lords_money_stack", SpawnChance = 100, Value = {Min = 10000, Max = 20000}},
    {SpawnPos = Vector(-4416.586914, -2091.716553, -149.783386), Ent = "lords_money_stack", SpawnChance = 100, Value = {Min = 10000, Max = 20000}},
    {SpawnPos = Vector(-4425.232422, -2060.834473, -149.783386), Ent = "lords_money_stack", SpawnChance = 100, Value = {Min = 10000, Max = 20000}},
    {SpawnPos = Vector(-4403.448242, -2045.222656, -149.783386), Ent = "lords_money_stack", SpawnChance = 100, Value = {Min = 10000, Max = 20000}},
    {SpawnPos = Vector(-4413.861328, -2017.502075, -149.783386), Ent = "lords_money_stack", SpawnChance = 100, Value = {Min = 10000, Max = 20000}},
    {SpawnPos = Vector(-4433.784668, -1989.796265, -149.783386), Ent = "lords_money_stack", SpawnChance = 100, Value = {Min = 10000, Max = 20000}},

    {SpawnPos = Vector(-4420.278320, -1920.169067, -149.762695), Ent = "lords_money", SpawnChance = 100, Value = {Min = 10000, Max = 20000}},
    {SpawnPos = Vector(-4429.146973, -1869.641846, -149.762695), Ent = "lords_money", SpawnChance = 100, Value = {Min = 10000, Max = 20000}},
    {SpawnPos = Vector(-4408.008789, -1874.939331, -149.762695), Ent = "lords_money", SpawnChance = 100, Value = {Min = 10000, Max = 20000}},
}

-- The PNG's are 1:3 ratio
-- so do something like 100x300px or 1000x3000px

--[[
    GuardAccuracy values
    1	The NPC will miss a large majority of their shots.
    2	The NPC will miss about half of their shots.
    3	The NPC will sometimes miss their shots.
    4	The NPC will rarely miss their shots.
    5	The NPC will almost never miss their shots.
]]--

RVault.VaultDoorID = 3082
RVault.Heists = {
    {
        ["Name"] = "EASY",
        ["MoneyReward"] = 1,
        ["GuardHealth"] = 2,
        ["GuardDamage"] = 1,
        ["SpawnRate"] = 1,

        ["NPCs"] = {
            {Class = "npc_rvault_tanker", Chance = 100},
        },

        ["GuardsToSpawn"] = {Min = 2, Max = 3},
        ["MaxGuards"] = 6,
        ["GuardMoney"] = 10,

        ["DrillTime"] = {Min = 10, Max = 12}, -- How long it takes the drill to drill the door
        ["BreakChance"] = 30, -- chance it can break every second
        ["Time"] = 5,
        ["GuardAccuracy"] = 1,
        ["Col"] = Color(40, 182, 80),
        ["PNG"] = "rvault/easy.png",
    },
    {
        ["Name"] = "MEDIUM",
        ["MoneyReward"] = 2,
        ["GuardHealth"] = 3,
        ["GuardDamage"] = 2,
        ["SpawnRate"] = 2,

        ["NPCs"] = {
            {Class = "npc_rvault_tanker", Chance = 100},
        },

        ["GuardsToSpawn"] = {Min = 3, Max = 4},
        ["MaxGuards"] = 7,
        ["GuardMoney"] = 10,

        ["DrillTime"] = {Min = 10, Max = 12}, -- How long it takes the drill to drill the door
        ["BreakChance"] = 30, -- chance it can break every second
        ["Time"] = 4,
        ["GuardAccuracy"] = 2,
        ["Col"] = Color(32, 123, 58),
        ["PNG"] = "rvault/medium.png",
    },
    {
        ["Name"] = "HARD",
        ["MoneyReward"] = 3,
        ["GuardHealth"] = 3,
        ["GuardDamage"] = 3,
        ["SpawnRate"] = 3,

        ["NPCs"] = {
            {Class = "npc_rvault_tanker", Chance = 100},
        },

        ["GuardsToSpawn"] = {Min = 4, Max = 5},
        ["MaxGuards"] = 8,
        ["GuardMoney"] = 10,

        ["DrillTime"] = {Min = 10, Max = 12}, -- How long it takes the drill to drill the door
        ["BreakChance"] = 30, -- chance it can break every second
        ["Time"] = 3,
        ["GuardAccuracy"] = 3,
        ["Col"] = Color(197, 130, 82),
        ["PNG"] = "rvault/extreme.png",
        ["Upgrades"] = {
            {ID = "DrillBreak", Col = Color(200, 200, 200)},
        }
    },
    {
        ["Name"] = "EXTREME",
        ["MoneyReward"] = 4,
        ["GuardHealth"] = 4,
        ["GuardDamage"] = 4,
        ["SpawnRate"] = 4,

        ["NPCs"] = {
            {Class = "npc_rvault_tanker", Chance = 100},
        },

        ["GuardsToSpawn"] = {Min = 5, Max = 6},
        ["MaxGuards"] = 9,
        ["GuardMoney"] = 10,

        ["DrillTime"] = {Min = 10, Max = 12}, -- How long it takes the drill to drill the door
        ["BreakChance"] = 30, -- chance it can break every second
        ["Time"] = 2,
        ["GuardAccuracy"] = 4,
        ["Col"] = Color(237, 91, 33),
        ["PNG"] = "rvault/hard.png",
        ["Upgrades"] = {
            {ID = "DrillBreak", Col = Color(200, 200, 200)},
            {ID = "MaybeMoneyLoss", Col = Color(255, 166, 0)},
        }
    },
    {
        ["Name"] = "INSANE",
        ["MoneyReward"] = 5,
        ["GuardHealth"] = 5,
        ["GuardDamage"] = 5,
        ["SpawnRate"] = 5,

        ["NPCs"] = {
            {Class = "npc_rvault_tanker", Chance = 100},
        },

        ["GuardsToSpawn"] = {Min = 6, Max = 7},
        ["MaxGuards"] = 10,
        ["GuardMoney"] = 10,

        ["DrillTime"] = {Min = 10, Max = 12}, -- How long it takes the drill to drill the door
        ["BreakChance"] = 30, -- chance it can break every second
        ["Time"] = 2,
        ["GuardAccuracy"] = 5,
        ["Col"] = Color(255, 0, 0),
        ["PNG"] = "rvault/insane.png",
        ["Upgrades"] = {
            {ID = "DrillBreak", Col = Color(200, 200, 200)},
            {ID = "LoseMoney", Col = Color(255, 100, 100)},
        }
    },
}

RVault.BankLocation = {
    cornerOne = Vector(-2952.696289, -1163.035400, -195.968750),
    cornerTwo = Vector(-4479.481934, -2151.733154, 15.968750),
}

RVault.GuardLocation = {
    Vector(-3484.180420, -1364.476929, -195.968750),
    Vector(-3429.934082, -1368.587036, -195.968750),
    Vector(-3349.892578, -1356.195801, -195.968750),
    Vector(-3420.582520, -1986.113037, -195.968750),
    Vector(-3566.857910, -2091.359863, -195.968750),
    Vector(-3719.586914, -2113.083496, -195.968750),
    Vector(-3012.735107, -1283.732544, -195.968750),
    Vector(-3125.853271, -1316.014771, -195.968750),
    Vector(-3243.661133, -1363.302002, -195.968750),
    Vector(-3024.235107, -2006.351685, -195.968750),
    Vector(-3143.507080, -2064.384033, -195.968750),
    Vector(-3231.109863, -1969.593384, -195.968750),
}

RVault.TellAll = true -- should we do global updates on some messages
RVault.StopHeistOnLeave = true -- should we cancel the heist when the last player leaves
RVault.SoundsEnabled = true -- should we play the sounds
RVault.GiveDrill = true -- Should we give them the drill when they join heist
RVault.NPCDropMoney = true -- should npcs drop money on death
RVault.DamageMultiplier = 0.2 -- extra damage npc's do (value * ["GuardDamage"]) so ["GuardDamage"] = 1 would do 20% extra damage
RVault.HeistCooldown = 0 -- how many seconds until we can start a new heist

RVault.BaseHealth = 50 -- Base health of npcs * by ["GuardHealth"]
RVault.BaseMinutes = (5 * 60) -- base time of the heist * by ["Time"]; this is in seconds
RVault.SpawnRate = {2, 4} -- base seconds to spawn guards * by ["SpawnRate"]


if CLIENT then return end

-- All the hooks at your disposable
hook.Add("RVault:DiedInHeist", "RVault:DiedInHeist", function(ply)
    if RVault:HasUpgrade("LoseMoney") then
        ply:addMoney(ply:getDarkRPVar("money") * .8) -- lose 20%
    end

    if RVault:HasUpgrade("MaybeMoneyLoss") and math.random(1, 100) <= 20 then
        -- 20% chance to lose 20% of your money
        ply:addMoney(ply:getDarkRPVar("money") * .8)
    end
end)

hook.Add("RVault:JoinedHeist", "RVault:JoinedHeist", function(ply)
end)

hook.Add("RVault:LeftHeist", "RVault:LeftHeist", function(ply)
end)

hook.Add("RVault:HeistStarted", "RVault:HeistStarted", function(ply)
    -- ply may return nil its who started it
end)

hook.Add("RVault:HeistEnded", "RVault:HeistEnded", function()
    -- this wont get called if we successfully complete the heist
end)

hook.Add("RVault:CompletedHeist", "RVault:CompletedHeist", function(tblPlayers)
end)
