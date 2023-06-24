RVault.ActiveHeist = RVault.ActiveHeist or nil

function RVault:HasUpgrade(id)
    if not RVault.Heists[RVault.ActiveHeist.Difficulty]["Upgrades"] then
        return false
    end

    for k, v in ipairs(RVault.Heists[RVault.ActiveHeist.Difficulty]["Upgrades"]) do
        if v.ID == id then
            return true
        end
    end
end

function RVault:ScreenMessage(ply, str, soundStr, seconds, tellAll)
    if ply == "None" then return end
    if tellAll and not RVault.TellAll then return end

    net.Start("RVault:ScreenMessage")
    net.WriteString(str)
    net.WriteString(soundStr)
    net.WriteUInt(seconds, 8)

    if isstring(ply) and ply == "All" then net.Broadcast() return end
    net.Send(ply)
end

function RVault:HeistComplete()
    hook.Run("RVault:CompletedHeist", RVault:GetPlayers())
    RVault:ScreenMessage("All", "HEIST COMPLETED", "https://cdn.discordapp.com/attachments/1113441772123725936/1122159706375462942/y2mate.is_-_GTA_Sound_Effects_-_Mission_Accomplished-I630MMdwC7k-192k-1687614116.mp3", 3, true)
    RVault:RemoveGuards()
    RVault:RemoveDrill()

    RVault.ActiveHeist = nil

    -- clear all clientside heist data
    net.Start("RVault:LeaveHeist")
    net.Broadcast()

    timer.Remove("RVault:GuardTimer")

    timer.Simple(6, function()
        RVault:LockVault()
    end)
end

function RVault:QuitHeist(failed, custommessasge)
    RVault:LockVault()
    RVault:RemoveGuards()
    RVault:RemoveDrill()

    RVault.ActiveHeist = nil
    RVault:ScreenMessage(failed and "All" or "None", custommessasge or "HEIST FAILED", "https://cdn.discordapp.com/attachments/1113441772123725936/1120424131272380436/mission_failed.mp3", 3, true)

    -- clear all clientside heist data
    net.Start("RVault:LeaveHeist")
    net.Broadcast()

    timer.Remove("RVault:GuardTimer")

    hook.Run("RVault:HeistEnded")
end

function RVault:GetPlayers()
    if not RVault.ActiveHeist then
        return {}
    end

    local tbl = {}
    for ply, v in pairs(RVault.ActiveHeist.Players) do
        if not v then continue end
        if not IsValid(ply) then continue end
        table.insert(tbl, ply)
    end
    return tbl
end

util.AddNetworkString("RVault:NetworkHeist")
function RVault:JoinHeist(ply)
    if not RVault.ActiveHeist then return end

    local EndTime = RVault.ActiveHeist.EndTime - CurTime()
    RVault.ActiveHeist.Players[ply] = true

    if RVault.GiveDrill then
        ply:Give("drill_swep")
    end

    net.Start("RVault:NetworkHeist")
    net.WriteUInt(EndTime, 32)
    net.Send(ply)

    hook.Run("RVault:JoinedHeist", ply)
end

util.AddNetworkString("RVault:LeaveHeist")
function RVault:LeaveHeist(ply)
    if RVault.ActiveHeist and IsValid(ply) then
        RVault.ActiveHeist.Players[ply] = false
   
        if RVault.StopHeistOnLeave and #RVault:GetPlayers() <= 0 then
            if #RVault:GetLoot() == 0 and RVault.ActiveHeist.VaultOpened and ply:Alive() then
			    RVault:HeistComplete()
            else
                if ply:Alive() then
                    RVault:QuitHeist(true, "HAILED FAILED: EVERYONE LEFT")
                else
                    RVault:QuitHeist(true, "HAILED FAILED: EVERYONE DIED")
                end
            end
        end
    end

    if RVault.GiveDrill then
        ply:StripWeapon("drill_swep")
    end

    net.Start("RVault:LeaveHeist")
    net.Send(ply)

    hook.Run("RVault:LeftHeist", ply)
end

util.AddNetworkString("RVault:ScreenMessage")
function RVault:StartHeist(difficultyINT, ply)
    if timer.Exists("RVault:Cooldown") then
        DarkRP.notify(ply, 1, 3, "Heist cooldown is active!")
        return
    end

    RVault:QuitHeist()

    local timeToComplete = RVault.BaseMinutes * RVault.Heists[difficultyINT]["Time"]
    RVault.ActiveHeist = {
        VaultOpened = false,
        StartTime = CurTime(),
        Difficulty = difficultyINT,
        EndTime = CurTime() + timeToComplete,
        TimeNeeded = timeToComplete,
        Players = {},
        Guards = {},
        Loot = {}
    }

    -- we can successfully start the heist
    -- all data has been created successfully 
    RVault:ScreenMessage("All", "HEIST STARTED", "https://cdn.discordapp.com/attachments/1113441772123725936/1120407700178731169/music.mp3", 3, true)
    RVault:SpawnGuards()

    hook.Run("RVault:HeistStarted", ply)
end

hook.Add("LordsUI:AreasLoaded", "RVault:LoadAreas", function()
    LordsUI:OnEnterArea(RVault.BankLocation.cornerOne, RVault.BankLocation.cornerTwo, function(ply)
        if not RVault.Criminals[team.GetName(ply:Team())] then
            return
        end

        if RVault.ActiveHeist then
            RVault:JoinHeist(ply)
            return
        end

        ply:ConCommand("rvault")
    end, "RVault:EnterBank")

    LordsUI:OnExitArea(RVault.BankLocation.cornerOne, RVault.BankLocation.cornerTwo, function(ply)
        if not ply:Alive() then
            hook.Run("RVault:DiedInHeist", ply)
            RVault:LeaveHeist(ply)
            return
        end
    
        RVault:LeaveHeist(ply)
    end, "RVault:ExitBank")
end)

util.AddNetworkString("RVault:StartHeist")
net.Receive("RVault:StartHeist", function(len, ply)
    local difficultyINT = net.ReadUInt(5)
    if difficultyINT < 1 or difficultyINT > #RVault.Heists then
        print("RVault: Invalid heist number (probably broken config try restarting)")
        return
    end

    if timer.Exists("RVault:Cooldown") then
        DarkRP.notify(ply, 1, 3, "Heist cooldown is active!")
        return
    end

    RVault:StartHeist(difficultyINT, ply)
    RVault:JoinHeist(ply)
end)

hook.Add("PostCleanupMap", "RVault:Cleanup", function()
    RVault:QuitHeist()
end)

hook.Add("RVault:HeistEnded", "RVault:EndedCooldown", function()
    timer.Create("RVault:Cooldown", RVault.HeistCooldown, 1, function() end)
end)

hook.Add("RVault:CompletedHeist", "RVault:CompletedCooldown", function()
    timer.Create("RVault:Cooldown", RVault.HeistCooldown, 1, function() end)
end)