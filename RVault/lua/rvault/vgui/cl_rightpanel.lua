local cache = {}
local PANEL = {}
function PANEL:Init()
    self.panels = {}
    self.selected = 1
    for k, v in ipairs(RVault.Heists) do
        local pnl = self:Add("DButton")
        pnl:SetText("")
        pnl.Paint = function(s, w, h)
            local col = v.Col or XeninUI.Theme.Green
            draw.RoundedBox(8, 0, 0, w, h, XeninUI.Theme.Navbar)
            draw.RoundedBoxEx(8, 0, 0, w, 50, col, true, true, false, false)
            draw.SimpleText(v.Name, "RVault:20", w/2, 25, color_white, 1, 1)

            cache[v.PNG] = cache[v.PNG] or Material(v.PNG)
            surface.SetMaterial(cache[v.PNG])
            surface.SetDrawColor(color_white)
            surface.DrawTexturedRect(10, 70, w - 20, (w - 20) / 3)

            local y = 70 + ((w - 20) / 3) + 10
            for _, v2 in ipairs(v.Upgrades or {}) do
                local DATA = RVault:GetUpgrade(v2.ID)
                local text, lines = RVault.WrapText(DATA.Text, w - 10, "RVault:15")
                draw.DrawText(text, "RVault:15", 5, y, v2.Col)
                y = y + (20*lines)
            end

            if s:IsHovered() or self.selected == k then
                surface.SetDrawColor(col.r, col.g, col.b, 20)
                surface.DrawRect(0, 50, w, h - 50)
            end
        end
        pnl.DoClick = function(s)
            self.OnSelected(k)
            self.selected = k
        end

        table.insert(self.panels, pnl)
    end
end

function PANEL:PerformLayout(w, h)
    local x = 0
    for k, v in ipairs(self.panels) do
        local wide = (w - ((#self.panels - 1) * 5)) / #self.panels
        v:SetSize(wide, h)
        v:SetPos(x)

        v:DockPadding(0, 70 + ((wide-20)/3) + 10, 0, 0)
        x = x + wide + 5
    end
end
vgui.Register("RVault.RightPanel", PANEL, "EditablePanel")