local doors = {}
doors["gm_functional_flatgrass3"] = {
{
	{{-6300.031250,7170.484863,14784.031250},{0,180,0},3000,3000,1500},
	{{-8000.617188,7170.068848,14784.031250},{0,0,0},3000,3000,1500},
},
{
{{-7150.324219,6160.034424,14784.031250},{0,90,0},3000,3000,2000},
{{-7150.324219,7860.620362,14784.031250},{0,-90,0},3000,3000,2000},
},
}


function loadMapPortals()
for i,v in ipairs(ents.FindByClass("linked_portal_door")) do v:Remove() end
if game.GetMap() == "gm_functional_flatgrass3" then
local entrancepos = Vector(2321,-2627,-14249)
local exitpos = Vector(-7710,-6711,14795)
local entranceang = Angle(0,-145,0)
local exitang = Angle(0,0,0)
if IsValid(casinoentrance) then casinoentrance:Remove() end
if IsValid(casinoexit) then casinoexit:Remove() end
casinoentrance = ents.Create("linked_portal_door")
casinoentrance:SetPos(entrancepos)
casinoentrance:SetAngles(entranceang)
casinoexit = ents.Create("linked_portal_door")
casinoexit:SetPos(exitpos)
casinoexit:SetAngles(exitang)
local entry = casinoentrance
local exit = casinoexit
entry:SetExit(exit)
exit:SetExit(entry)
entry:SetWidth(100)
entry:SetHeight(150)
entry:SetDisappearDist(1300)

exit:SetWidth(100)
exit:SetHeight(129)
exit:SetDisappearDist(1500)
entry:Spawn()
entry:Activate()
exit:Spawn()
exit:Activate()
end
for i,v in ipairs(doors[game.GetMap()] or {}) do
local fdoor = ents.Create("linked_portal_door")
local sdoor = ents.Create("linked_portal_door")
local finfo = v[1]
local sinfo = v[2]
local fpos = Vector(finfo[1][1],finfo[1][2],finfo[1][3])
local fang = Angle(finfo[2][1],finfo[2][2],finfo[2][3])
local spos = Vector(sinfo[1][1],sinfo[1][2],sinfo[1][3])
local sang = Angle(sinfo[2][1],sinfo[2][2],sinfo[2][3])
fdoor:SetPos(fpos)
sdoor:SetPos(spos)
fdoor:SetAngles(fang)
sdoor:SetAngles(sang)
local fwidth = finfo[3]
local fheight = finfo[4]
local fdisappear = finfo[5]
local swidth = sinfo[3]
local sheight = sinfo[4]
local sdisappear = sinfo[5]
fdoor:SetExit(sdoor)
sdoor:SetExit(fdoor)
fdoor:SetWidth(fwidth)
sdoor:SetWidth(swidth)
fdoor:SetHeight(fheight)
sdoor:SetHeight(sheight)
fdoor:SetDisappearDist(fdisappear)
sdoor:SetDisappearDist(sdisappear)
fdoor:Spawn()
fdoor:Activate()
sdoor:Spawn()
sdoor:Activate()
end
end

--[[hook.Add("InitPostEntity","LoadMapPortals",function()
loadMapPortals()
end)
concommand.Add("resetcasinodoor",function(ply)
if IsValid(ply) and ply:IsSuperAdmin() then
loadMapPortals()
end
end)
loadMapPortals()]]--