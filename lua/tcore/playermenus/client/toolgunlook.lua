local matScreen = Material( "models/weapons/v_toolgun/screen" )
local txBackground = surface.GetTextureID( "models/weapons/v_toolgun/screen_bg" )
local testBackground	= surface.GetTextureID( "vgui/alpha-back" )
local glogo = surface.GetTextureID("vgui/titlebaricon")
-- GetRenderTarget returns the texture if it exists, or creates it if it doesn't
local RTTexture = GetRenderTarget( "GModToolgunScreen", 256, 256 )

surface.CreateFont( "GModToolScreen", {
	font	= "Helvetica",
	size	= 60,
	weight	= 900
} )

surface.CreateFont( "GModToolScreenHelping", {
	font	= "Helvetica",
	size	= 30,
	weight	= 900
} )


local function DrawScrollingText( text, y, texwide )

	local w, h = surface.GetTextSize( text )
	w = w + 64

	y = y - h / 2 -- Center text to y position

	local x = RealTime() * 250 % w * -1

	while ( x < texwide ) do

		surface.SetTextColor( 0, 0, 0, 255 )
		surface.SetTextPos( x + 3, y + 3 )
		surface.DrawText( text )

		surface.SetTextColor( 255, 255, 255, 255 )
		surface.SetTextPos( x, y )
		surface.DrawText( text )

		x = x + w

	end

end


--[[---------------------------------------------------------
	We use this opportunity to draw to the toolmode
		screen's rendertarget texture.
-----------------------------------------------------------]]
local tcoreoverride = CreateClientConVar("toolgun_compass_enabled", "1")
local blacktoolgun = CreateClientConVar("toolgun_black","0")
local function func(self)

	local TEX_SIZE = 256
	local mode = GetConVarString( "gmod_toolmode" )
	local oldW = ScrW()
	local oldH = ScrH()

	-- Set the material of the screen to our render target
	matScreen:SetTexture( "$basetexture", RTTexture )

	local OldRT = render.GetRenderTarget()

	-- Set up our view for drawing to the texture
	render.SetRenderTarget( RTTexture )
	render.SetViewPort( 0, 0, TEX_SIZE, TEX_SIZE )
	cam.Start2D()

		-- Background
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetTexture( txBackground )
		surface.DrawTexturedRect( 0, 0, TEX_SIZE, TEX_SIZE )

		-- Give our toolmode the opportunity to override the drawing
		if ( self:GetToolObject() && self:GetToolObject().DrawToolScreen ) then

			self:GetToolObject():DrawToolScreen( TEX_SIZE, TEX_SIZE )

		elseif TCore.OverrideToolScreen and tcoreoverride:GetBool() then
            TCore.OverrideToolScreen(TEX_SIZE,TEX_SIZE)
        elseif blacktoolgun:GetBool() then
			surface.SetDrawColor(Color(0,0,0,255))
			surface.DrawRect(0,0,TEX_SIZE,TEX_SIZE)
			surface.SetFont( "GModToolScreen" )
			DrawScrollingText( "#tool." .. mode .. ".name", 104, TEX_SIZE )
		else
			surface.SetFont( "GModToolScreen" )
			DrawScrollingText( "#tool." .. mode .. ".name", 104, TEX_SIZE )
		end

	cam.End2D()
	render.SetRenderTarget( OldRT )
	render.SetViewPort( 0, 0, oldW, oldH )

end

local WEAP = weapons.Get("gmod_tool")
WEAP.RenderScreen = func
weapons.Register(WEAP,"gmod_tool")



function TCore.OverrideToolScreen(w,h)
local eyeang = LocalPlayer():EyeAngles()
local yaw = (eyeang.y+90)/180*math.pi
local TEX_SIZE = 256
local center = TEX_SIZE/2
local size = TEX_SIZE/4
local nsize = TEX_SIZE/8
local x,y = center+math.cos(yaw+math.pi*0.5)*size,center+math.sin(yaw+math.pi*0.5)*size
local dirx,diry = center-x,center-y
local x1,y1 = x+math.sin(math.atan2(dirx,diry)+0.5)*nsize,y+math.cos(math.atan2(dirx,diry)+0.5)*nsize
local x2,y2 = x+math.sin(math.atan2(dirx,diry)-0.5)*nsize,y+math.cos(math.atan2(dirx,diry)-0.5)*nsize
local trace = LocalPlayer():GetEyeTrace()
local hitpos = trace.HitPos
local mode = GetConVarString( "gmod_toolmode" )
surface.SetDrawColor(255,255,255,255)
surface.SetTexture(testBackground)
surface.DrawTexturedRectRotated(w/2,h/2,w*2,h*2,CurTime()*10)
surface.SetDrawColor(20,50,20,250)
surface.DrawRect(0,0,w,h)

surface.SetDrawColor(Color(255,255,255))
surface.DrawLine(center,center,x,y)
surface.DrawLine(x,y,x1,y1)
surface.DrawLine(x,y,x2,y2)
surface.SetFont( "Trebuchet24" )
surface.SetTextColor( 255,255,255,255 )
local tw,th = surface.GetTextSize("N")
surface.SetTextPos(center-tw/2,center)
surface.DrawText('N')
surface.SetFont( "GModToolScreen" )
DrawScrollingText( "#tool." .. mode .. ".name", 200, TEX_SIZE )
surface.SetFont( "GModToolScreenHelping" )
DrawScrollingText( "#tool." .. mode .. ".desc", 235, TEX_SIZE )
end
