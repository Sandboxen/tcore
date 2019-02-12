local helpcontents = {
{"Główne zalozenia serwera",[[Serwer posiada 2 tryby:
PVP oraz Budowanie
Staramy sie dostarczac wiele zabawy dla graczy poprzez dobierane przez nas dodatki :)
Na serwerze znajdziesz:
1. Zintegrowany system pieniedzy ktore mozesz wydac w serwerowym kasynie!
2. Pieniadze mozesz zdobywac poprzez lowienie ryb :D
3. Znajdziesz takze wiele autorskich skryptow :)
4. Mnóstwo ciekawych addonów z workshopa
]]},
{"Ważne Komendy",[[
!build - Przełączenie na tryb budowania.
!pvp - Przełączenie na tryb pvp.
!goto - Teleportacja do innego gracza.
!motd - Regulamin.
!grupa - Nasza grupa steam.
!addony - Lista dodatków na serwerze do zasubskrybowania.
!pacignore - Menu ignorowania paców innych graczy.
]]},
{"Pomoc Dotycząca ACF/StarFall",[[
Napewno zastanawiasz się co znaczy ACF/SF w nazwie,
jeżeli jednak wiesz co to jest to brawo dla ciebie :)
Aby Pobrać te dwie rzeczy:
1 Wchodzimy na stronę (Przez przeglądarke (chrome itp))
ACF - https://github.com/nrlulz/acf
StarFall - https://github.com/thegrb93/starfallex
2 Szukamy Zielonego Klawisza Z Napisem "Clone Or Download"
3 Klikamy to a następnie klikamy Download ZIP
4 Po pobraniu Zipa
5 Wypakowujemy folder (nazwadodatku)-master
6 Otrzymany Folder Wrzucamy do: Folder Z garrysmodem/garrysmod/addons
7 Restartujemy grę
8 PROFIT !!!111oneone
]]
}}
HelpSwep = {}
function HelpSwep.gui()
HelpSwep.helpgui = vgui.Create("DPanel")
	HelpSwep.helpgui:SetSize(1024, 512)
	HelpSwep.helpgui:SetPos(ScrW() / 2 - HelpSwep.helpgui:GetWide() / 2, ScrH() / 2 - HelpSwep.helpgui:GetTall() / 2)
	--HelpSwep.helpgui:ShowCloseButton( true )
	--HelpSwep.helpgui:SetDraggable( true )
	HelpSwep.helpgui:MakePopup()
	--HelpSwep.helpgui:SetTitle("HELP MENU")
local header = vgui.Create("DPanel",HelpSwep.helpgui)
header:SetSize(HelpSwep.helpgui:GetWide(),27)
function header:Paint(w,h)
surface.SetDrawColor(Color(33, 150, 243))
surface.DrawRect(0,0,w,h)
draw.SimpleText("Pomoc","Coolvetica25",10,0,Color( 255, 255, 255, 255 ),TEXT_ALIGN_LEFT)
end
local clsbutton = vgui.Create("DButton",header)
clsbutton.DoClick = function() HelpSwep.helpgui:Remove() end
clsbutton:SetFont("Coolvetica30")
clsbutton:SetTextColor(Color(255,255,255,255))
clsbutton:SetText("X")
clsbutton:SetSize(45,45)
clsbutton:SetPos(HelpSwep.helpgui:GetWide() - clsbutton:GetWide(),-5)
clsbutton.Paint = function() end
local dtree = vgui.Create( "DTree", HelpSwep.helpgui )
dtree:SetPos(5,35)
dtree:SetSize(150,HelpSwep.helpgui:GetTall() - 40)
dtree:SetPadding(5)
dtree.Paint = function() end
local node = dtree:AddNode("Pomoc","icon16/bricks.png")
node:SetExpanded(true)
local scrollbar = vgui.Create("DScrollPanel", HelpSwep.helpgui)
scrollbar:SetPos(180,35)
scrollbar:SetSize(HelpSwep.helpgui:GetWide() - 190,HelpSwep.helpgui:GetTall() - 40)
scrollbar.Paint = function(w,h)
	--draw.RoundedBox(8,0,0,scrollbar:GetWide(),scrollbar:GetTall(),Color(255,255,255))
end
local info =  vgui.Create("DLabel",scrollbar)
info:SetText("Aby wybrać kategorię pomocy, kliknij po lewej !")
info:SetPos(6,0)
info:SetFont("Trebuchet24")
info:SetTextColor(Color(0,0,0))
info:SizeToContents()

for i,v in ipairs(helpcontents) do
	local nde = node:AddNode(helpcontents[i][1],"icon16/bricks.png")
	nde.id = i
end
dtree.DoClick = function()
local clicked = dtree:GetSelectedItem()
local txt = "Aby wybrać kategorię pomocy, kliknij po lewej !"
if clicked and clicked.id then

txt = helpcontents[clicked.id][2]
else
txt = "Aby wybrać kategorię pomocy, kliknij po lewej !"
end
surface.SetFont(info:GetFont())
local x,y = surface.GetTextSize(txt)
info:SetText(txt)
info:SetSize(x,y)
end
end