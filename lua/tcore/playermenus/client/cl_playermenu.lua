local icon = "icon64/playermodel.png"
list.Set(
	"DesktopWindows",
	"PlayerMenu",
	{
		title = "Menu Gracza",
		icon = icon,
		width = 960,
		height = 700,
		onewindow = true,
		init = function(icn, pnl)
			pnl:Remove()
			RunConsoleCommand("tomke_player_menu")
		end
	}
)
local function openPlayerMenu()
if IsValid(playermenupanel) then
	playermenupanel:Remove()
else
		esc.openMenu()
end
end

concommand.Add("tomke_player_menu",openPlayerMenu)
--
-- 3D2D Escape Menu by thelastpenguin aka Gareth
-- The author of this script takes no responsability for damages incured in it's use including loss or disruption of service or otherwise.
-- All derivitave scripts must keep this credit banner to the author and must credit the author thelastpenguin in any releases
-- other than that you can do whatever the fvck you want with it :)
--
esc = esc or {}

local render, surface = _G.render, _G.surface

local blur = Material('pp/blurscreen')
local function panelPaintBlur(w,h)
	render.SetStencilEnable(true)

	render.ClearStencil()

	render.SetStencilWriteMask( 1 )
	render.SetStencilTestMask( 1 )
	render.SetStencilReferenceValue( 1 )

	render.SetStencilCompareFunction( STENCIL_ALWAYS )
	render.SetStencilPassOperation( STENCIL_REPLACE )
	render.SetStencilFailOperation( STENCIL_KEEP )
	render.SetStencilZFailOperation( STENCIL_KEEP )

	surface.SetDrawColor(0,0,0,1)
	surface.DrawRect(0,0,w,h)

	render.SetStencilCompareFunction( STENCIL_EQUAL )
	render.SetStencilPassOperation( STENCIL_KEEP )
	render.SetStencilFailOperation( STENCIL_KEEP )
	render.SetStencilZFailOperation( STENCIL_KEEP )

	cam.Start2D()
		local scrW, scrH = ScrW(), ScrH()
		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(blur)
		for i = 1, 4 do
			blur:SetFloat('$blur', (i / 4) * (10))
			blur:Recompute()
			render.UpdateScreenEffectTexture()
			surface.DrawTexturedRect(0, 0, scrW, scrH)
		end
	cam.End2D()

	render.SetStencilEnable(false)
end


--
-- CUSTOM AVATAR PANEL
--
local PANEL = {}
function PANEL:Init()
	self.avatarImage = vgui.Create('AvatarImage', self)
	self.avatarImage:SetPaintedManually(true)
	self:PerformLayout()
end
function PANEL:SetPlayer(pl, size)
	self.avatarImage:SetPlayer(pl, size)
end
function PANEL:PerformLayout()
	local w, h = self:GetSize()
	self.avatarImage:SetSize(w,h)

	self.circle = {}
	local wedges = 36
	local wedge_angle = math.pi*2/wedges
	local r = w * 0.5
	for i = 1, wedges do
		table.insert(self.circle, {
			x = math.cos(i*wedge_angle) * r + r,
			y = math.sin(i*wedge_angle) * r + r,
		})
	end
end

function PANEL:Paint(w,h)

	render.SetStencilEnable(true)

	render.ClearStencil()

	render.SetStencilWriteMask( 1 )
	render.SetStencilTestMask( 1 )
	render.SetStencilReferenceValue( 1 )

	render.SetStencilCompareFunction( STENCIL_ALWAYS )
	render.SetStencilPassOperation( STENCIL_REPLACE )
	render.SetStencilFailOperation( STENCIL_KEEP )
	render.SetStencilZFailOperation( STENCIL_KEEP )

	surface.SetDrawColor(0,0,0,255)
	draw.NoTexture()
	surface.DrawPoly(self.circle)

	render.SetStencilCompareFunction( STENCIL_EQUAL )
	render.SetStencilPassOperation( STENCIL_KEEP )
	render.SetStencilFailOperation( STENCIL_KEEP )
	render.SetStencilZFailOperation( STENCIL_KEEP )

	self.avatarImage:SetPaintedManually(false)
	self.avatarImage:PaintManual()
	self.avatarImage:SetPaintedManually(true)

	render.SetStencilEnable(false)
end
vgui.Register('esc_menu_avatarimage', PANEL)



surface.CreateFont('esc_btn_font', {
	font = 'Roboto',
	size = 18*1.5,
	weight = 1000,
})

surface.CreateFont('esc_name_font', {
	font = 'Roboto',
	size = 22*1.5,
	weight = 1000,
})


esc.openMenu = function()
	--gui.EnableScreenClicker(true)

	playermenupanel = vgui.Create('DPanel')
	local panel = playermenupanel
	panel.CalcLocation = function(vOrigin, vAngles)
		local pos, ang, scale
		pos = LocalPlayer():GetPos()
		ang = LocalPlayer():EyeAngles()
		ang.p = 0
		ang.r = 0
		ang:RotateAroundAxis(ang:Up(), 120)
		ang:RotateAroundAxis(ang:Right(), 90)
		ang:RotateAroundAxis(ang:Up(), -90)

		scale = 0.125

		pos = pos + ang:Forward() * 50
		pos = pos - ang:Right() * 40
		pos = pos - ang:Up() * 30
		return pos, ang, scale
	end

	panel:SetSize(600, 600);
	panel:Center()
	panel:MakePopup()

	function panel:OnRemove()
		--gui.EnableScreenClicker(false)
		hook.Remove('CalcView', 'hookname')
	end

	--vgui.make3d( panel );

	hook.Add('CalcView', 'hookname', function(pl, pos, ang, fov, nearz, farz)
		ang.p = 0
		ang:RotateAroundAxis(ang:Up(),90)

		pos = pos - ang:Forward() * 50*2.25 + ang:Right() * 0*1.25
		pos.z = pos.z - 20
		--vgui.set3d2dOrigin(pos, ang)
		return {
			origin = pos,
			angles = ang,
			fov = fov,
			drawviewer = true
		}
	end)

	local w, h = panel:GetSize()
	function panel:Paint(w,h) end

	local header = vgui.Create('DPanel', panel)
	header.Paint = function(_, w, h)
		--panelPaintBlur(w,h)
		surface.SetDrawColor(33,150,243,255)
		surface.DrawRect(0,0,w,h)
		surface.SetDrawColor(0,0,0,255)
		surface.DrawOutlinedRect(0,0,w,h)
	end
	header:SetSize(w, 64+8)

	local btnClose = vgui.Create('DButton', header)
	btnClose:SetFont('esc_name_font')
	btnClose:SetTextColor(color_white)
	btnClose:SetText('X')
	btnClose:SetSize(45,45)
	btnClose:SetPos(header:GetWide() - btnClose:GetWide(),0)
	btnClose.Paint = function() end
	btnClose.DoClick = function() panel:Remove() end

	local avatarImage = vgui.Create('esc_menu_avatarimage', panel)
	avatarImage:SetPos(4,4)
	avatarImage:SetSize(64, 64)
	avatarImage:SetPlayer(LocalPlayer(), 64)

	local lblName = Label(LocalPlayer():Name(), header)
	lblName:SetFont('esc_name_font')
	lblName:SizeToContents()
	lblName:Center()

	local body = vgui.Create('DPanel', panel)
	body:SetPos(0, header:GetTall() + 4)
	body:SetSize(w, h - header:GetTall() - 8)
	--[[local icon = vgui.Create( "DModelPanel", body )
	icon:SetPos(0,0)
	icon:SetSize( w, h - header:GetTall() - 8 )
	icon:SetModel( LocalPlayer():GetModel() )
	function icon.Entity:GetPlayerColor() return LocalPlayer():GetPlayerColor() end]]

	function body:Paint(w,h)
		--panelPaintBlur(w,h)
		surface.SetDrawColor(0,0,0, 50)
		surface.DrawRect(0,0,w,h)

		surface.SetDrawColor(0,0,0)
		surface.DrawOutlinedRect(0,0,w,h)
	end
	local function btnClickOff(el,onof)
		if onof == true then
		el.DoClick = nil
	else
		el.DoClick = el.action
	end
	end
	local function addButton(parent, text, action)
		local btn = vgui.Create('DButton', parent)
		btn:SetSize(parent:GetWide(), 33)
		btn:SetFont 'esc_btn_font'
		btn:SetTextColor(color_white)
		btn:SetText(text)
		btn:DockMargin(4,2,4,2)
		btn:Dock(TOP)
		btn.action = action
		function btn:OnCursorEntered()
			self:SetTextColor(color_black)
		end
		function btn:OnCursorExited()
			self:SetTextColor(color_white)
		end
		function btn:Paint(w,h)
			if self:IsHovered() then
				surface.SetDrawColor(200,200,200,110)
				surface.DrawRect(0,0,w,h)
			else
				surface.SetDrawColor(0,0,0,150)
				surface.DrawRect(0,0,w,h)
			end
		end
		btn.DoClick = action
		return btn
	end
	local function addAltText(btn, alt)
		local original = btn:GetText()
		btn.OnCursorEntered = function(self)
			self:SetText(alt)
			self:SetTextColor(color_black)
		end
		btn.OnCursorExited = function(self)
			self:SetText(original)
			self:SetTextColor(color_white)
		end
		return btn
	end

	local function addConfirm(btn)
		local onCursorEntered = btn.OnCursorEntered
		local onCursorExited = btn.OnCursorExited
		local doClick = btn.DoClick
		local defaultText = btn:GetText()

		btn.DoClick =  function() end

		local function clickOverride()
			btn:SetText('[click to confirm]')
			btn:SetTextColor(color_black)

			local function reset()
				btn:SetText(defaultText)
				btn:SetTextColor(color_white)
				btn.OnMouseReleased = clickOverride
				btn.OnMousePressed = function() end
				btn.onCursorExited = onCursorExited
			end

			btn.OnCursorExited = function(...)
				onCursorExited(...)
				reset()
			end

			btn.OnMousePressed = function(...)
				doClick(...)
				reset()
			end
		end

		btn.OnMouseReleased = clickOverride
	end

	local function addSection(parent, title)
		local panel = vgui.Create('DPanel', parent)
		panel:SetWide(parent:GetWide())
		panel:DockMargin(5,2,5,2)
		panel:Dock(TOP)
		panel:DockPadding(0,18*1.5,0,0)

		local label = Label(title, panel)
		label:SetFont('esc_btn_font')
		label:SetTextColor(Color(255,255,255))
		label:SizeToContents()
		label:CenterHorizontal()

		function panel:Paint(w,h)
			surface.SetDrawColor(255,255,255,255)

			surface.DrawLine(0,15,w*0.5-label:GetWide()*0.5,15)
			surface.DrawLine(0,16,w*0.5-label:GetWide()*0.5,16)

			surface.DrawLine(w*0.5+label:GetWide()*0.5+10,15,w,15)
			surface.DrawLine(w*0.5+label:GetWide()*0.5+10,16,w,16)

			surface.DrawLine(0,15,0,h)
			surface.DrawLine(1,15,1,h)

			surface.DrawLine(w,15,w,h)
			surface.DrawLine(w-1,15,w-1,h)

			surface.DrawLine(0,h,w,h)
			surface.DrawLine(0,h-1,w,h-1)
		end

		function panel:PerformLayout()
			local h = 0
			for k,v in pairs(self:GetChildren())do
				local x, y = v:GetPos()
				if y + v:GetTall() > h then h = y + v:GetTall() end
			end
			self:SetTall(h+4)
		end

		return panel
	end

	local mainopts = addSection(body,"Funkcje")
	local tagbutt = addButton(mainopts,"Zmien Tag na Czacie",function()
		--playermenupanel:Remove()
			local frame = vgui.Create("DFrame")
			frame:SetSize(500,150)
			frame:SetTitle("Zmiana Tagu")
			frame:Center()
			frame:MakePopup()
	local TextEntry = vgui.Create( "DTextEntry",frame)
	TextEntry:SetPos(100,40)
	TextEntry:SetSize(300,20)
	TextEntry:SetPlaceholderText("Wpisz Tag (Zostaw puste aby usunąć tag)")
	local butt = vgui.Create("DButton",frame)
	butt:SetSize(150,30)
	butt:SetPos(50,100)
	butt:SetText("Zmień")
	butt.DoClick = function()
		frame:Remove()
		net.Start("TagNetworker")
		net.WriteString(TextEntry:GetText())
		net.SendToServer()
	end
	local cbutt = vgui.Create("DButton",frame)
	cbutt:SetSize(150,30)
	cbutt:SetPos(300,100)
	cbutt:SetText("Anuluj")
	cbutt.DoClick = function()
		frame:Remove()
	end
	end)
	local tagbutt = addButton(mainopts,"Zmien Nick",function()
		--playermenupanel:Remove()
			local frame = vgui.Create("DFrame")
			frame:SetSize(500,150)
			frame:SetTitle("Zmiana Nicku")
			frame:Center()
			frame:MakePopup()
	local TextEntry = vgui.Create( "DTextEntry",frame)
	TextEntry:SetPos(100,40)
	TextEntry:SetSize(300,20)
	TextEntry:SetPlaceholderText("Wpisz Nick (Zostaw puste aby zresetowac nick)")
	local butt = vgui.Create("DButton",frame)
	butt:SetSize(150,30)
	butt:SetPos(50,100)
	butt:SetText("Zmień")
	butt.DoClick = function()
		frame:Remove()
		net.Start("NickNetworker")
		net.WriteString(TextEntry:GetText())
		net.SendToServer()
	end
	local cbutt = vgui.Create("DButton",frame)
	cbutt:SetSize(150,30)
	cbutt:SetPos(300,100)
	cbutt:SetText("Anuluj")
	cbutt.DoClick = function()
		frame:Remove()
	end
	end)
	if LocalPlayer().buildmode == true then
		addButton(mainopts,"Tryb PVP",function() LocalPlayer():ConCommand('ulx pvp\n') playermenupanel:Remove() end)
	else
		addButton(mainopts,"Tryb Budowania",function() LocalPlayer():ConCommand('ulx build\n') playermenupanel:Remove() end)
	end
	addButton(mainopts,"Edycja HUDu",function() LocalPlayer():ConCommand('phud_edit\n') playermenupanel:Remove() end)
	addButton(mainopts, "Pomoc",function() LocalPlayer():ConCommand("say !pomoc\n") playermenupanel:Remove() end)
	--[[local serverList = addSection(body, 'SERVERS')
	local function addServerButton(name, ip)
		addConfirm(addAltText(addButton(serverList, name, function()
			LocalPlayer():ConCommand('connect '..ip..'\n')
		end), '[CLICK TO JOIN]'))
	end
	addServerButton('DARKRP', 'rp.superiorservers.co')
	addServerButton('DARKRP #2', 'rp2.superiorservers.co')
	addServerButton('RAG KOM', 'rk.superiorservers.co')
	addServerButton('GUN GAME', 'gg.superiorservers.co')

	local webList = addSection(body, 'WEB LINKS')
	addAltText(addButton(webList, 'FORUMS', function()
		gui.OpenURL('https://superiorservers.co/')
	end), 'CLICK TO OPEN')
	addAltText(addButton(webList, 'BAN LIST', function()
		gui.OpenURL('https://portal.superiorservers.co/bans')
	end), 'CLICK TO OPEN')
	addAltText(addButton(webList, 'STAFF LIST', function()
		gui.OpenURL('https://portal.superiorservers.co/staff')
	end), 'CLICK TO OPEN')

	addButton(body, 'DISCONNECT', function() LocalPlayer():ConCommand('disconnect\n') end):Dock(BOTTOM)
	addButton(body, 'OPTIONS', function() gui.ActivateGameUI() panel:Remove() end):Dock(BOTTOM)]]
end


local timeout = 0
hook.Add("PlayerButtonDown","BindMenuPlayer",function(ply,s)
	if not IsValid(ply) then return end
if s == KEY_F3 and ply == LocalPlayer() and CurTime() > timeout then
timeout = CurTime()+0.5
LocalPlayer():ConCommand("tomke_player_menu")
end
end)