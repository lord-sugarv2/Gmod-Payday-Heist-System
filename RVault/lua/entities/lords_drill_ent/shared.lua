ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Drill"
ENT.Author = "Lord Sugar"
ENT.Category = "RVault"
ENT.Spawnable = true
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "MaxDrillTime")
    self:NetworkVar("Int", 1, "DrillTime")

    self:NetworkVar("Bool", 0, "Broken")
end