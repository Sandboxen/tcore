local doors = TCore.doors
local function addFont(font, t)
		for i = 1, 100 do
			t.size = i
			surface.CreateFont(font .. i, t)
		end
end

--MOVE THIS OK

-- Default textscreens font
addFont("Coolvetica outlined", {
	font = "coolvetica",
	weight = 400,
	antialias = false,
	outline = true
})

addFont("Coolvetica", {
	font = "coolvetica",
	weight = 400,
	antialias = false,
	outline = false
})

-- Trebuchet
addFont("Screens_Trebuchet outlined", {
	font = "Trebuchet MS",
	weight = 400,
	antialias = false,
	outline = true
})

addFont("Screens_Trebuchet", {
	font = "Trebuchet MS",
	weight = 400,
	antialias = false,
	outline = false
})

-- Arial
addFont("Screens_Arial outlined", {
	font = "Arial",
	weight = 600,
	antialias = false,
	outline = true
})

addFont("Screens_Arial", {
	font = "Arial",
	weight = 600,
	antialias = false,
	outline = false
})

-- Roboto Bk
addFont("Screens_Roboto outlined", {
	font = "Roboto Bk",
	weight = 400,
	antialias = false,
	outline = true
})

addFont("Screens_Roboto", {
	font = "Roboto Bk",
	weight = 400,
	antialias = false,
	outline = false
})

-- Helvetica
addFont("Screens_Helvetica outlined", {
	font = "Helvetica",
	weight = 400,
	antialias = false,
	outline = true
})

addFont("Screens_Helvetica", {
	font = "Helvetica",
	weight = 400,
	antialias = false,
	outline = false
})

-- akbar
addFont("Screens_Akbar outlined", {
	font = "akbar",
	weight = 400,
	antialias = false,
	outline = true
})

addFont("Screens_Akbar", {
	font = "akbar",
	weight = 400,
	antialias = false,
	outline = false
})

-- csd
addFont("Screens_csd outlined", {
	font = "csd",
	weight = 400,
	antialias = false,
	outline = true
})

addFont("Screens_csd", {
	font = "csd",
	weight = 400,
	antialias = false,
	outline = false
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
		surface.SetMaterial(Material("models/wireframe"))
		surface.SetDrawColor(Color(255,255,255))
		surface.DrawTexturedRect(-finfo[3]*5,-finfo[4]*5,finfo[3]*10,finfo[4]*10)
    cam.End3D2D()
end
if sinfo[6] then
    cam.Start3D2D(spos,sang+Angle(0,90,90),0.1)
        surface.SetTextColor(Color(255,255,255,255))
        surface.SetFont("Coolvetica100")
        local tw = surface.GetTextSize(sinfo[6])
        surface.SetTextPos(-tw/2,0)
        surface.DrawText(sinfo[6])
		surface.SetMaterial(Material("models/wireframe"))
		surface.SetDrawColor(Color(255,255,255))
		surface.DrawTexturedRect(-sinfo[3]*5,-sinfo[4]*5,sinfo[3]*10,sinfo[4]*10)
    cam.End3D2D()
end
end
end)
