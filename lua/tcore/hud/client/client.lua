local tag = "PolskiHUD"
PHUD = {}
PHUD.posx,PHUD.posy = 120,ScrH() - 120
PHUD.size = 150
PHUD.enabled = CreateClientConVar("phud_enabled","1")
PHUD.maincolor = Color(200,0,20,255)
PHUD.outlinecolor = Color(0,100,0,200)
PHUD.armorcolor = Color(127,127,127,255)
PHUD.fontcolor = Color(255,255,255,255)
--local contextmenu = false
--local col = Color(0,0,0,0)
--local healthicon = Material("icon16/heart.png")
--local armoricon = Material("icon16/shield.png")
--local usericon = Material("icon16/user.png")
--local coinicon = Material("icon16/coins.png")

surface.CreateFont("PHUD_Name",{
  font = "Roboto",
  size = 24,
  outline = true,
  antialias = true,
})
surface.CreateFont("PHUD_Event",{
  font = "Verdana",
  size = 24,
  outline = true,
  antialias = true,
})



local chudhide = {
    ["CHudHealth"] = true,
    ["CHudBattery"] = true,
    ["CHudAmmo"] = true,
    ["CHudSecondaryAmmo"] = true,
}

hook.Add("HUDShouldDraw",tag,function(s)
if chudhide[s] and PHUD.enabled:GetBool() then return false end
end)

local function doHook()
if IsValid(LocalPlayer()) then
local myhp = LocalPlayer():GetMaxHealth()
local myarmor = 100
local defaultsets = util.TableToJSON({PHUD.maincolor,PHUD.armorcolor,PHUD.outlinecolor,PHUD.fontcolor})
local settings = file.Read("phud.txt")
settings = settings or defaultsets
local sets = util.JSONToTable(settings)
PHUD.maincolor = sets[1]
PHUD.armorcolor = sets[2]
PHUD.outlinecolor = sets[3]
PHUD.fontcolor = sets[4]
hook.Add("HUDPaint",tag,function()
if not PHUD.enabled:GetBool() then return end
if pk_pills and IsValid(pk_pills.getMappedEnt(LocalPlayer())) then return end
if LocalPlayer() then
local x,y = PHUD.posx,PHUD.posy
myarmor = Lerp(FrameTime() * 3,myarmor,LocalPlayer():Armor())
myhp = Lerp(FrameTime() * 3,myhp,LocalPlayer():Health())
local hpmuchshow = Lerp(myhp / LocalPlayer():GetMaxHealth(),-100,100)
local armormuchshow = Lerp(myarmor / 100,-110,110)
surface.SetTextColor(Color(255,255,255))
draw.NoTexture()
surface.SetDrawColor(PHUD.outlinecolor)
surface.DrawTexturedRectRotated(x,y,150,150,45)

render.SetScissorRect(x-120,y-armormuchshow,x + 130,y + 110,true)
draw.NoTexture()
surface.SetDrawColor(PHUD.armorcolor)
surface.DrawTexturedRectRotated(x,y,150-20,150-20,45)
render.SetScissorRect(0,0,0,0,false)

render.SetScissorRect(x-120,y-hpmuchshow,x + 130,y + 110,true)
draw.NoTexture()
surface.SetDrawColor(PHUD.maincolor)
surface.DrawTexturedRectRotated(x,y,150-30,150-30,45)
render.SetScissorRect(0,0,0,0,false)

surface.SetFont("weaponicons")
local hpw = surface.GetTextSize(LocalPlayer():Health())
draw.NoTexture()
surface.SetTextColor(PHUD.fontcolor)
surface.SetTextPos(PHUD.posx-hpw / 2,PHUD.posy-35)
surface.DrawText(LocalPlayer():Health())
surface.SetFont("weaponiconsselected")
surface.SetTextPos(PHUD.posx-hpw / 2,PHUD.posy-35)
surface.DrawText(LocalPlayer():Health())

surface.SetFont("PHUD_Name")
local namew = surface.GetTextSize(LocalPlayer():Name())
local nameposx,nameposy = x + 15,y-90
local namepoly = {}
namepoly[1] = {x = nameposx + namew + 30,y = nameposy}
namepoly[2] = {x = nameposx + namew + 30,y = nameposy + 30}
namepoly[3] = {x = nameposx + 30,y = nameposy + 30}
namepoly[4] = {x = nameposx,y = nameposy}
draw.NoTexture()
surface.SetDrawColor(PHUD.outlinecolor)
surface.DrawPoly(namepoly)
surface.SetTextPos(x + 40,y-87)
surface.SetTextColor(PHUD.fontcolor)
surface.DrawText(LocalPlayer():Name())
if cebulacoin then
surface.SetFont("PHUD_Event")
local txt = cebulacoin.event or ""
if txt != "" then
local moneyw = surface.GetTextSize(txt)
local moneyposx,moneyposy = x + 93,y-15
local moneypoly = {}
  moneypoly[1] = {x = moneyposx + moneyw + 30,y = moneyposy}
  moneypoly[2] = {x = moneyposx + moneyw + 30,y = moneyposy + 30}
  moneypoly[3] = {x = moneyposx,y = moneyposy + 30}
  moneypoly[4] = {x = moneyposx + 15,y = moneyposy + 15}
  moneypoly[5] = {x = moneyposx,y = moneyposy}
draw.NoTexture()
surface.SetDrawColor(PHUD.outlinecolor)
surface.DrawPoly(moneypoly)
surface.SetTextPos(x + 110,y-13)
surface.SetTextColor(PHUD.fontcolor)
surface.DrawText(txt)
surface.SetFont("PHUD_Name")
end
end

local weapon = LocalPlayer():GetActiveWeapon()
if IsValid(weapon) then
    local clip = tonumber(weapon:Clip1()) or -1
	local allAmmo = LocalPlayer():GetAmmoCount(weapon:GetPrimaryAmmoType() or "")
	local ammow = surface.GetTextSize("Ammo: " .. clip .. "/" .. allAmmo)
	local ammoposx,ammoposy = x + 57,y + 20
	local ammopoly = {}
	ammopoly[1] = {x = ammoposx + ammow + 30,y = ammoposy}
	ammopoly[2] = {x = ammoposx + ammow + 30,y = ammoposy + 30}
	ammopoly[3] = {x = ammoposx,y = ammoposy + 30}
	ammopoly[4] = {x = ammoposx + 30,y = ammoposy}
	if clip > 0 or allAmmo > 0 then
        draw.NoTexture()
        surface.SetDrawColor(PHUD.outlinecolor)
        surface.DrawPoly(ammopoly)
        surface.SetTextPos(x + 80,y + 23)
        surface.SetTextColor(PHUD.fontcolor)
        surface.DrawText("Ammo: " .. clip .. "/" .. allAmmo)
	end
	--local clip2 = tonumber(weapon:Clip2())
	local allAmmo2 = LocalPlayer():GetAmmoCount(weapon:GetSecondaryAmmoType() or "")
	local ammow2 = surface.GetTextSize("Secondary: " .. allAmmo)
	local ammoposx2,ammoposy2 = x + 17,y + 60
	local ammopoly2 = {}
	ammopoly2[1] = {x = ammoposx2 + ammow2 + 30,y = ammoposy2}
	ammopoly2[2] = {x = ammoposx2 + ammow2 + 30,y = ammoposy2 + 30}
	ammopoly2[3] = {x = ammoposx2,y = ammoposy2 + 30}
	ammopoly2[4] = {x = ammoposx2 + 30,y = ammoposy2}
	--print(clip2)
  if allAmmo > 0 then
    draw.NoTexture()
	surface.SetDrawColor(PHUD.outlinecolor)
	surface.DrawPoly(ammopoly2)
	surface.SetTextPos(x + 43,y + 63)
    surface.SetTextColor(PHUD.fontcolor)
	surface.DrawText("Secondary: " .. allAmmo2)
	end

end

if LocalPlayer().buildmode != nil then
  surface.SetFont("PHUD_Name")
	local buildmodew = surface.GetTextSize(LocalPlayer().buildmode and "Build" or "PVP")
	local buildmodeposx,buildmodeposy = x +57,y-50
	local buildmodepoly = {}
	buildmodepoly[1] = {x = buildmodeposx + buildmodew + 30,y = buildmodeposy}
	buildmodepoly[2] = {x = buildmodeposx + buildmodew + 30,y = buildmodeposy + 30}
	buildmodepoly[3] = {x = buildmodeposx + 30,y = buildmodeposy + 30}
	buildmodepoly[4] = {x = buildmodeposx,y = buildmodeposy}
  draw.NoTexture()
	surface.SetDrawColor(PHUD.outlinecolor)
	surface.DrawPoly(buildmodepoly)
	surface.SetTextPos(x + 80,y-48)
  surface.SetTextColor(PHUD.fontcolor)
	surface.DrawText(LocalPlayer().buildmode and "Build" or "PVP")
end

if LocalPlayer():GetNWString("OnSpawn",false) then
  local hudinfo = "Nie mozesz uzywac broni w tym miejscu"
  surface.SetFont("PHUD_Event")
  local infow = surface.GetTextSize(hudinfo)
  local infoposx,infoposy = x-55,y-141

  draw.NoTexture()
  local infopoly = {}
  infopoly[1] = {x = infoposx,y = infoposy}
	infopoly[2] = {x = infoposx + 30,y = infoposy}
	infopoly[3] = {x = infoposx + 30,y = infoposy + 60}
	infopoly[4] = {x = infoposx,y = infoposy + 90 }
  surface.SetDrawColor(PHUD.outlinecolor)
  surface.DrawPoly(infopoly)
  surface.DrawRect(infoposx + 30,infoposy,infow-15,30)
  surface.SetTextPos(infoposx + 10,infoposy + 3)
  surface.SetTextColor(PHUD.fontcolor)
  surface.DrawText(hudinfo)
  surface.SetFont("PHUD_Name")
end

surface.SetDrawColor(Color(0,0,0,255))
--LEFTUP
draw.NoTexture()
surface.DrawLine(x,y-107,x-107,y)
surface.DrawLine(x,y-106,x-106,y)
--RIGHTUP
draw.NoTexture()
surface.DrawLine(x,y-107,x + 107,y)
surface.DrawLine(x,y-106,x + 106,y)
--LEFTDOWN
draw.NoTexture()
surface.DrawLine(x,y + 107,x-107,y)
surface.DrawLine(x,y + 106,x-106,y)
--RIGHTDOWN
draw.NoTexture()
surface.DrawLine(x,y + 107,x + 107,y)
surface.DrawLine(x,y + 106,x + 106,y)


end
end)
end
end
doHook()
hook.Add("InitPostEntity",tag,doHook)





--VGUI--

local function savesets()
local tab = {PHUD.maincolor,PHUD.armorcolor,PHUD.outlinecolor,PHUD.fontcolor}
file.Write("phud.txt",util.TableToJSON(tab))
end

local function makecombovar(parent,var,txt,x,y,w,h)
local p = vgui.Create("DPanel",parent)
p:SetSize(w,h)
p:SetPos(x,y)
p.Paint = function() end
local label = vgui.Create("DLabel",p)
label:SetFont("Coolvetica30")
label:SetText(txt)
label:SetTextColor(Color(255,255,255,255))
label:Dock(TOP)
label:SetContentAlignment(5)
local mixer = vgui.Create("DColorMixer",p)
mixer:Dock(TOP)
mixer:SetColor(PHUD[var])
function mixer:ValueChanged(col)
PHUD[var] = col
end
end

local function EditGui()
local frame = vgui.Create("DFrame")
frame:SetSize(420,500)
frame:Center()
frame:MakePopup()
frame:SetTitle("HUD Editor")
frame.Paint = function(_,w,h)
surface.SetDrawColor(Color(20,20,20,200))
surface.DrawRect(0,0,w,h)
end
local panel = vgui.Create("DScrollPanel",frame)
panel:Dock(FILL)
makecombovar(panel,"maincolor","Kolor HP",0,0,385,250)
makecombovar(panel,"armorcolor","Kolor Armora",0,260,385,250)
makecombovar(panel,"outlinecolor","Kolor Tla",0,520,385,250)
makecombovar(panel,"fontcolor","Kolor Czcionki",0,780,385,250)

function frame:OnClose()
frame:Remove()
savesets()
end
end
concommand.Add("phud_edit",EditGui)

local fontsize = 70

surface.CreateFont("PHUD_3d2dBig",{
font = "Tahoma",
size = fontsize,
weight = 880,
additive = false,
})

surface.CreateFont("PHUD_3d2dBig_blur",{
font = "Tahoma",
size = fontsize,
weight = 800,
blursize = 7,
additive = false
})

surface.CreateFont("PHUD_3d2dInfo",{
font = "Tahoma",
size = fontsize,
weight = 880,
additive = false,
})

surface.CreateFont("PHUD_3d2dInfo_blur",{
font = "Tahoma",
size = fontsize,
weight = 800,
blursize = 7,
additive = false
})

PHUD.icons = {
["wrench"] =  Material("icon16/wrench.png"),
["alert"] = Material("icon16/exclamation.png")
}

hook.Add("HUDDrawTargetID","TargetIDOverride",function()
    local ply = LocalPlayer():GetEyeTrace().Entity
    if (ply:IsPlayer()) then
        local _,_ = ply:GetPos():ToScreen()
        local healthpercent = (ply:Health() / ply:GetMaxHealth()) * 100
        local a, b, _ = ColorToHSV(team.GetColor(ply:Team()))
        local nick = string.Replace(ply:Name(), "\n","")
        draw.DrawText(ply:Name() .. "\n" .. healthpercent .. "%\n" ,"ChatFont",ScrW() / 2,ScrH() / 1.8,HSVToColor(a,b * 0.8,0.9),TEXT_ALIGN_CENTER)
        end
    return false
end)