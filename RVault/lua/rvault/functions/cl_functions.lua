XeninUI:CreateFont("RVault:75", 75)
XeninUI:CreateFont("RVault:50", 50)
XeninUI:CreateFont("RVault:20", 20)
XeninUI:CreateFont("RVault:15", 15)

function RVault:OpenMenu()
    if IsValid(self.menu) then self.menu:Remove() end
    self.menu = vgui.Create("XeninUI.Frame")
    self.menu:SetTitle("Bank Heists")
    self.menu:SetSize(ScrW() * .65, 450)
    self.menu:Center()
    self.menu:MakePopup()

    local panel = self.menu:Add("RVault.Menu")
    panel:Dock(FILL)
end

function RVault:GetMax(id)
    local num = 0
    for k, v in ipairs(RVault.Heists) do
        num = math.max(num, v[id])
    end

    return num
end

function RVault:GetUpgrade(id)
    for k, v in ipairs(RVault.Upgrades) do
        if id == v.ID then return v end
    end
end

local function findNewlines(str)
    local indices = {}
    local index = 1

    while true do
        index = string.find(str, "\n", index)
        if not index then
        break
        end
        table.insert(indices, index)
        index = index + 1
    end

    return #indices + 1
end

-- https://github.com/TomDotBat/pixel-ui/blob/master/lua/pixelui/drawing/cl_text.lua
local subString = string.sub
local textWrapCache = {}
local setFont = surface.SetFont
local getTextSize = surface.GetTextSize
function RVault.WrapText(text, width, font)
    local chachedName = text .. width .. font
    local lines = 1
    if textWrapCache[chachedName] then
        lines = findNewlines(textWrapCache[chachedName])
        return textWrapCache[chachedName], lines
    end

    setFont(font)
    local textWidth = getTextSize(text)

    if textWidth <= width then
        textWrapCache[chachedName] = text
        return text, lines
    end

    local totalWidth = 0
    local spaceWidth = getTextSize(' ')
    text = text:gsub("(%s?[%S]+)", function(word)
        local char = subString(word, 1, 1)
        if char == "\n" or char == "\t" then
            totalWidth = 0
            lines = lines + 1
        end

        local wordlen = getTextSize(word)
        totalWidth = totalWidth + wordlen

        if wordlen >= width then
            local splitWord, splitPoint = charWrap(word, width - (totalWidth - wordlen), width)
            totalWidth = splitPoint
            return splitWord, lines
        elseif totalWidth < width then
            return word, lines
        end

        if char == ' ' then
            totalWidth = wordlen - spaceWidth
            lines = lines + 1
            return '\n' .. subString(word, 2), lines
        end

        totalWidth = wordlen
        lines = lines + 1
        return '\n' .. word, lines
    end)

    textWrapCache[chachedName] = text
    return text, lines
end

concommand.Add("rvault", function()
    RVault:OpenMenu()
end)

net.Receive("RVault:ScreenMessage", function()
    local str = net.ReadString()
    local url = net.ReadString()
    local time = net.ReadUInt(8)
    if RVault.SoundsEnabled then
        sound.PlayURL(url, "mono", function(s)
            if not IsValid(s) then return end
            s:Play()
        end)
    end

    local slant = 120

    surface.SetFont("RVault:75")
    local w, h = surface.GetTextSize(str)

    local panel = vgui.Create("DPanel")
    panel:SetSize(0, h + 50)
    panel:SizeTo(w + 100, h + 50, .3, 0)
    panel.OnSizeChanged = function(s)
        s:SetPos((ScrW()/2) - (s:GetWide()/2), 50)
    end
    panel.Paint = function(s, w, h)
        draw.RoundedBox(25, 0, 0, w, h, Color(255, 100, 100, 255))
        draw.SimpleText(str, "RVault:75", w/2, h/2, color_white, 1, 1)
    end
    timer.Simple(time-.3, function()
        panel:SizeTo(0, h + 50, .3, 0)
    end)
    timer.Simple(time, function()
        panel:Remove()
    end)
end)

RVault.HeistData = RVault.HeistData or nil
net.Receive("RVault:NetworkHeist", function() 
    RVault.HeistData = {}
    RVault.HeistData.EndTime = CurTime() + net.ReadUInt(32)
end)

net.Receive("RVault:LeaveHeist", function()
    RVault.HeistData = nil
end)

hook.Add("HUDPaint", "RVault:DrawHeistInfo", function()
    if RVault.HeistData then
        local w, h = 180, 80
        local x, y = 20, 80

        local timeLeft = string.FormattedTime(RVault.HeistData.EndTime - CurTime(), "%02i:%02i")
        draw.RoundedBox(25, x, y, w, h, Color(255, 100, 100, 255))
        draw.SimpleText(timeLeft, "RVault:50", x + (w / 2), y + (h / 2), color_white, 1, 1)
    end
end)

local w, h = 1000, 150
local x, y, margin = -(w/2), 0, 10
hook.Add("PostDrawTranslucentRenderables", "RVault:DrawNPCHealth", function()	
	for _, npc in ipairs(ents.FindByClass("npc_*")) do
		if not IsValid(npc) then continue end
		if npc:Health() <= 0 then continue end

		npc.InfoPos = npc:LocalToWorld(npc:OBBCenter()*2) + (npc:GetUp() * 6)
		cam.Start3D2D(npc.InfoPos, Angle(0, EyeAngles().y - 90, 90), .05)
            XeninUI:DrawRoundedBox(20, x, y, w, h, XeninUI.Theme.Background)
            XeninUI:DrawRoundedBox(20, x + margin, y + margin, (npc:Health() / npc:GetMaxHealth()) * (w - (margin * 2)), h - (margin * 2), XeninUI.Theme.Purple)

            local barCount = math.ceil(npc:GetMaxHealth() / 25)
            for i = 1, (barCount-1) do
                XeninUI:DrawRoundedBox(0, x + ((w / barCount)*i), y, margin, h, XeninUI.Theme.Background)
            end
        cam.End3D2D();
	end
end);