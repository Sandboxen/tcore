local ENT = {}
ENT.Base = "base_anim"
ENT.PrintName = "InfoTable"
ENT.Author = "Tomekb530"
ENT.Information = "Table with informations"
ENT.Category = "Tomekb530"

ENT.Editable = true
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.RenderGroup = RENDERGROUP_BOTH
if SERVER then

function ENT:Initialize()

	self:SetModel( "models/hunter/plates/plate5x5.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox

        local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end
else
local bdraw = trequire("bdraw")
local gxml = trequire("gxml")
local fagmins1 ={
["Bezimienny_33"] = {"76561198285170286"},
["Raptoistus"] = {"76561198218416708"},
["Jak ci Ruski Nick Przeszkadza"] = {"76561198179740577",25},
["Szufler"] = {"76561198103676045"}
}
local howMuchFagmins1 = table.Count(fagmins1)
local fagmins2 ={
["Młaszter"] = {"76561198053747306"},
["Dr.Freezeman"] = {"76561198206103919"},
["PawikLord"] = {"76561198177720590"},
["DominikPc73"] = {"76561198109040046",50},
}

local howMuchFagmins2 = table.Count(fagmins2)
local Rainbow  = 0
local anim =0
local reverse = false
local maxdist = 2000
function ENT:Draw()
--if LocalPlayer():Name() == "Tomekb530" then return end
if not bdraw or not gxml then return end
if self:GetPos():Distance(LocalPlayer():GetPos()) < 2000 then
local alpha = 255
if anim > 1900 and reverse == false then
reverse = true
elseif anim < 100 and reverse == true then
reverse = false
end

if reverse == true then
anim = anim -5
else
anim = anim +5
end
if Rainbow == 360 then Rainbow = 0 end
if bDrawingDepth then return end
	local x,y = -1000,-1000
    p = p or tdui.Create()
local Timestamp = os.time()
local TimeString = os.date( "%H:%M:%S" , Timestamp )
local DateString = os.date("%d/%m/%Y", Timestamp)
	surface.SetFont("Coolvetica100")
	local twidth = surface.GetTextSize("24:24:60")
    p:Rect(x,y, x*-2,y*-2,Color(0,32,0), Color(255, 255, 255,255))
	if chathud:GetTwitchEmoticon("25") then
	--p:Mat(chathud:GetTwitchEmoticon("25"),900-anim,900-anim,72,72,Color(255,255,255,100))
	--p:Mat(chathud:GetTwitchEmoticon("25"),x+anim,y+anim,72,72,Color(255,255,255,100))
	--p:Mat(chathud:GetTwitchEmoticon("25"),900-anim,y+anim,72,72,Color(255,255,255,100))
	--p:Mat(chathud:GetTwitchEmoticon("25"),x+anim,900-anim,72,72,Color(255,255,255,100))
	end
  p:Text(TimeString, "Coolvetica100", x+150, y+30)
	p:Text(DateString, "Coolvetica100", 800, y+30)
	p:Text("Witaj !","Screens_Roboto100",0,0-600)
	p:Text("Lista Administratorów","Screens_Roboto60",400,-230)
	p:Text("(KLIKNIJ NA PROFILOWE ABY WEJSC NA PROFIL)","Screens_Roboto30",400,-180)
	local k = 0
	for i,v in pairs(fagmins1) do
		local ply = i
		if FindPlayer(v[1]) then ply = FindPlayer(v[1]):Name() end
		local color = v[3] or Color(255,255,255,255)
		local size = v[2] or 50
		p:Text(ply,"Screens_Roboto"..size,600,100+(k*250),color)
		if p:Button("","Screens_Roboto1",500,(k*250)-100,200,200,Color(0,0,0,0),Color(0,0,0,0)) then
		gui.OLDOpenURL("http://steamcommunity.com/profiles/"..v[1])
		end
		k=k+1
	end
	k=0
	for i,v in pairs(fagmins2) do
		local ply = i
		if FindPlayer(v[1]) then ply = FindPlayer(v[1]):Name() end
		local color = v[3] or Color(255,255,255,255)
		local size = v[2] or 50
		p:Text(ply,"Screens_Roboto"..size,200,100+(k*250),color)
		if p:Button("","Screens_Roboto1",100,(k*250)-100,200,200,Color(0,0,0,0),Color(0,0,0,0)) then
		gui.OLDOpenURL("http://steamcommunity.com/profiles/"..v[1])
		end
		k=k+1
	end
	k=0
	p:Text("Znajdujesz sie na serwerze Polski Sandbox","Screens_Roboto100",0,0-500)
	p:Text("Wlasciciel :","Screens_Roboto70",-800+(450/2),-260)
	if p:Button("","Screens_Roboto1",-950+(450/2),-150,300,300,Color(0,0,0,0),Color(0,0,0,0)) then
		gui.OLDOpenURL("http://steamcommunity.com/profiles/76561198235918302")
		end
	p:Text("Tomekb530","Screens_Roboto50",-800+(450/2),-200,HSVToColor(Rainbow*2,1,1))
	p:Rect(50,-150,700,1150,Color(0,0,0,0),Color(150,0,0),5)
	if chathud:GetDiscordEmoticon("1F600") then
	p:Mat(chathud:GetDiscordEmoticon("1F600"),0+130,0-580,72,72)
	end
	if p:Button("Addony","Screens_Roboto100",0-800,450,450,200,Color(150,0,0),Color(255,0,0)) then
		LocalPlayer():ConCommand("ulx addony")
	end
	if p:Button("Grupa","Screens_Roboto100",0-800,200,450,200,Color(150,0,0),Color(255,0,0)) then
		LocalPlayer():ConCommand("ulx grupa")
	end
	if p:Button("Pomoc","Screens_Roboto100",0-800,700,450,200,Color(150,0,0),Color(255,0,0)) then
	 LocalPlayer():ConCommand("say !pomoc")
	end

    p:Cursor()
    p:Render(self:LocalToWorld(Vector(0,0,0)),self:LocalToWorldAngles(Angle(90,90,0)), 0.1)
	cam.Start3D2D(self:LocalToWorld(Vector(0,0,0)),self:LocalToWorldAngles(Angle(0,0,0)), 0.1 )
	draw.CircularSteamAvatar("76561198235918302","large",-800+(450/2),0,150,36,Color(255,255,255))
	local k = 0
	for i,v in pairs(fagmins1) do
		draw.CircularSteamAvatar(v[1],"large",600,(k*250),100,36,Color(255,255,255,255))
		k=k+1
	end
	k=0
	for i,v in pairs(fagmins2) do
		draw.CircularSteamAvatar(v[1],"large",200,(k*250),100,36,Color(255,255,255,255))
		k=k+1
	end
	k=0
	cam.End3D2D()
end
end
end
return ENT