AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/payday2/otherprops/money.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self.value = 1
end

function ENT:Use(ply)
	ply:addMoney(self.value)
	DarkRP.notify(ply, 1, 3, "collected "..DarkRP.formatMoney(self.value))

	if self.HeistLoot then
		RVault.ActiveHeist.Loot[self] = false
	end

	self:Remove()
end

function ENT:Think()
	local players = LordsUI:PlayersWithinDistance(self:GetPos(), 42)
	if #players < 1 then return end
	players[1]:addMoney(self.value)
	DarkRP.notify(ply, 1, 3, "collected "..DarkRP.formatMoney(self.value))

	self:Remove()
end