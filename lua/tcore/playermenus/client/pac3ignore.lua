function PacIgnoreList()
	local dframe = vgui.Create("DPanel")
		dframe:SetSize(300,300)
		dframe:Center()
		dframe:MakePopup()
	local header = vgui.Create("DPanel",dframe)
	header:SetSize(dframe:GetWide(),27)
	function header:Paint(w,h)
	surface.SetDrawColor(Color(33, 150, 243))
	surface.DrawRect(0,0,w,h)
	draw.SimpleText("Ignorowanie Paca","Coolvetica25",10,0,Color( 255, 255, 255, 255 ),TEXT_ALIGN_LEFT)
	end

	--dframe:SetTitle("Ignorowanie Paca")
	local dscrollpanel = vgui.Create("DScrollPanel",dframe)
	dscrollpanel:Dock(FILL)
	local plys = {}
	for i,v in ipairs(player.GetAll()) do
		if v ~= LocalPlayer() then table.insert(plys,v) end
end
	for i,v in ipairs(plys) do
	local DLabel = vgui.Create( "DLabel", dscrollpanel )
	DLabel:SetPos(23,18 + 15 * i)
	DLabel:SetText( v:Name() )
	DLabel:SetTextColor(Color(0,0,0,255))
	DLabel:SizeToContents()
	local DCheckBox = vgui.Create( "DCheckBox",dscrollpanel)
	DCheckBox:SetValue(v.pac_ignored and 1 or 0)
	DCheckBox:SetPos(5,18 + 15 * i)
	function DCheckBox:OnChange( asdf )
	if asdf then
		pac.IgnoreEntity(v)
		else
		pac.UnIgnoreEntity(v)
	end
	end
end
local clsbutton = vgui.Create("DButton",dscrollpanel)
clsbutton.DoClick = function()
	dframe:Remove() end
clsbutton:SetFont("Coolvetica30")
clsbutton:SetTextColor(Color(255,255,255,255))
clsbutton:SetText("X")
clsbutton:SetSize(45,45)
clsbutton:SetPos(dframe:GetWide() - clsbutton:GetWide(),-5)
clsbutton.Paint = function() end
end
