SWEP.PrintName = "Drill"
SWEP.Author = "Lord Sugar"
SWEP.Slot = 0
SWEP.SlotPos = 1

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Ammo = "none"
SWEP.DrawAmmo = false

SWEP.HoldType = "normal"
SWEP.Category = "RVault"
SWEP.UseHands = false

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Primary.Automatic = false

SWEP.ViewModel = ""
SWEP.WorldModel = ""

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

function SWEP:PrimaryAttack()
    if CLIENT then return end

    local tr = self.Owner:GetEyeTrace()
    if not tr.Entity:isDoor() or IsValid(tr.Entity.Drill) or tr.Entity:doorIndex() ~= RVault.VaultDoorID then return end

    local ang = tr.HitNormal:Angle()
    ang[2] = ang[2] + 180

    local ent = ents.Create("lords_drill_ent")
    ent:SetPos(Entity(1):GetEyeTrace().HitPos)
    ent:Spawn()
    ent:SetAngles(ang)
    ent:SetParent(tr.Entity)
    tr.Entity.Drill = ent

    self:Remove()
end

function SWEP:SecondaryAttack() return end