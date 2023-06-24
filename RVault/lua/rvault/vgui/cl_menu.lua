local PANEL = {}
function PANEL:Init()
    self.LeftPanel = self:Add("RVault.LeftPanel")
    self.LeftPanel:Dock(LEFT)

    self.RightPanel = self:Add("RVault.RightPanel")
    self.RightPanel:Dock(FILL)
    self.RightPanel:DockMargin(5, 5, 5, 5)
    self.RightPanel.OnSelected = function(num)
        self.LeftPanel.selected = num
    end
end

function PANEL:PerformLayout(w, h)
    self.LeftPanel:SetWide(w*.25)
end
vgui.Register("RVault.Menu", PANEL, "EditablePanel")