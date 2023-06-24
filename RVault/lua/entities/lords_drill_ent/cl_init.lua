include("shared.lua")

local str, time = "", CurTime()
local up, count, maxCount = true, 1, 4
local function elipsis()
	if CurTime() < time then return str end

	count = up and count + 1 or count - 1
	if count == maxCount then
		up = not up
	elseif count == 0 then
		up = true
	end

	str = ""
	for i = 1, count do str = str.."." end

	time = CurTime() + 0.2
	return str
end

function ENT:Draw()
	self:DrawModel()

	local angle = self:GetAngles()
	angle:RotateAroundAxis(angle:Up(), 270)
	angle:RotateAroundAxis(angle:Forward(), 60)

	local pos = self:GetPos()
	pos = pos + (self:GetUp() * 1.8)
	pos = pos + (self:GetRight() * -10.7)
	pos = pos + (self:GetForward() * -4.75)

	local w, h = 159, 127
	local y = (h / 2) - ((20 + 10 + 15) / 2) - 10
	cam.Start3D2D(pos, angle, .05)
		draw.SimpleText(self:GetBroken() and "BROKEN" or "DRILLING"..elipsis(), "RVault:20", w/2, y, color_white, 1, 0)

		if self:GetBroken() then
			draw.SimpleText("use to fix" or "DRILLING"..elipsis(), "RVault:20", w/2, y + 20 + 10, color_white, 1, 0)
		else
			surface.SetDrawColor(XeninUI.Theme.Primary)
			surface.DrawRect(20, y + 20 + 10, w - 40, 15)

			local percentage = (self:GetDrillTime() / self:GetMaxDrillTime())
			surface.SetDrawColor(XeninUI.Theme.Blue)
			surface.DrawRect(20, y + 20 + 10, percentage * (w-40), 15)
		end
	cam.End3D2D()
end

function ENT:Think()
	self:SetNextClientThink(CurTime() + 0.1)

	if self:GetBroken() then return end
	local effectdata = EffectData()
	effectdata:SetOrigin(self:GetPos() + Vector(0, 0, 7))
	util.Effect("ManhackSparks", effectdata)
end