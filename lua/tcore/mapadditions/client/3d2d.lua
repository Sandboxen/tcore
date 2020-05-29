local doors = TCore.doors
surface.CreateFont("Coolvetica50",{
    font = "Coolvetica",
    size = 50
})
surface.CreateFont("Coolvetica100",{
    font = "Coolvetica",
    size = 50
})
hook.Add("PostDrawTranslucentRenderables","OverDoorView",function()
for i,v in ipairs(doors[game.GetMap()] or {}) do
local finfo = v[1]
local sinfo = v[2]
local fpos = Vector(finfo[1][1],finfo[1][2],finfo[1][3])
local fang = Angle(finfo[2][1],finfo[2][2],finfo[2][3])
local spos = Vector(sinfo[1][1],sinfo[1][2],sinfo[1][3])
local sang = Angle(sinfo[2][1],sinfo[2][2],sinfo[2][3])
if finfo[6] then
    cam.Start3D2D(fpos,fang+Angle(0,90,90),0.1)
        surface.SetTextColor(Color(255,255,255,255))
        surface.SetFont("Coolvetica50")
        local tw = surface.GetTextSize(finfo[6])
        surface.SetTextPos(-tw/2,0)
        surface.DrawText(finfo[6])
    cam.End3D2D()
end
if sinfo[6] then
    cam.Start3D2D(spos,sang+Angle(0,90,90),0.1)
        surface.SetTextColor(Color(255,255,255,255))
        surface.SetFont("Coolvetica100")
        local tw = surface.GetTextSize(sinfo[6])
        surface.SetTextPos(-tw/2,0)
        surface.DrawText(sinfo[6])
    cam.End3D2D()
end
end
end)
