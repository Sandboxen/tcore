local doors = TCore.doors

function loadMapPortals()
for i,v in ipairs(ents.FindByClass("linked_portal_door")) do v:Remove() end
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

hook.Add("InitPostEntity","LoadMapPortals",function()
loadMapPortals()
end)
concommand.Add("resetcasinodoor",function(ply)
if IsValid(ply) and ply:IsSuperAdmin() then
loadMapPortals()
end
end)
loadMapPortals()