AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/payday2/equipments/drill.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	local drillTime = math.random(RVault.Heists[RVault.ActiveHeist.Difficulty]["DrillTime"].Min, RVault.Heists[RVault.ActiveHeist.Difficulty]["DrillTime"].Max)
	self:SetMaxDrillTime(drillTime)
	self:SetDrillTime(0)
end

function ENT:Use()
	self:SetBroken(false)
end

function ENT:Think()
	if self:GetParent().Opened then
		self:Remove()
	end

	self.DrillTimer = self.DrillTimer or CurTime() + 1
	if self.DrillTimer <= CurTime() then
		self.DrillTimer = CurTime() + 1

		if self:GetBroken() then return end
		self:SetDrillTime(self:GetDrillTime() + 1)
	
		if math.random(1, 100) <= RVault.Heists[RVault.ActiveHeist.Difficulty]["BreakChance"] then
			if not RVault:HasUpgrade("DrillBreak") then
				for _, ply in ipairs(RVault:GetPlayers()) do
					RVault:ScreenMessage(ply, "DRILL BROKE", "https://cdn.discordapp.com/attachments/1113441772123725936/1121128960420483122/power_down.mp3", 3)
				end
			end
			self:SetBroken(true)
		end

		if self:GetDrillTime() >= self:GetMaxDrillTime() then
			RVault:OpenVault()
		end
	end
end