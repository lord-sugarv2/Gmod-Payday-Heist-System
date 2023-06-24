local PANEL = {}
function PANEL:Init()
    self.selected = 1
    self.startHeist = self:Add("XeninUI.ButtonV2")
    self.startHeist:Dock(BOTTOM)
    self.startHeist:DockMargin(5, 0, 5, 5)
    self.startHeist:SetTall(35)
    self.startHeist:SetRoundness(6)
    self.startHeist:SetText("START HEIST")
    self.startHeist.DoClick = function()
        net.Start("RVault:StartHeist")
        net.WriteUInt(self.selected, 5)
        net.SendToServer()
    end

    self.options = {}
    self.optionPanels = self:Add("Panel")
    self.optionPanels:Dock(FILL)
    self.optionPanels:DockMargin(5, 5, 5, 5)
    self.optionPanels.PerformLayout = function(s, w, h)
        y, h = 0, h - ((#self.options - 1) * 5)
        for k, v in ipairs(self.options) do
            v:SetSize(w, h / #self.options)
            v:SetY(y)
            y = y + 5 + (h / #self.options)
        end
    end

    for k, v in ipairs(RVault.Options) do
        local pnl = self.optionPanels:Add("DPanel")
        pnl.Paint = function(s, w, h)
            draw.SimpleText(v.NiceName, "RVault:20", 0, 0, color_white)
            
            local int, margin, x = RVault:GetMax(v.ID), 4, 0
            local boxWidth = (w - ((int - 1) * margin)) / int
            for i = 1, int do
                col = i <= RVault.Heists[self.selected][v.ID] and (v.Col or XeninUI.Theme.Green) or XeninUI.Theme.Primary
                draw.RoundedBox(6, x, 25 + 3, boxWidth, math.min(boxWidth, h - 26 - 5), col)
                x = x + boxWidth + margin
            end
        end

        table.insert(self.options, pnl)
    end
end
vgui.Register("RVault.LeftPanel", PANEL, "EditablePanel")