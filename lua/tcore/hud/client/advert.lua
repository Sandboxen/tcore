function markupWithoutParse(str)
	str = str:gsub("%b::", "")
	str = str:gsub("%b<>","")
	return str
end
--ADVERT
local function showAdvert(texte)
	local matrix = Matrix()
	local kek = 0
		local s = 0
	kek = 50
local textm = class:new("Markup")
	textm.w = ScrW()
	textm.x = 0
	textm.y = 0
	textm:Parse("<font=Coolvetica50>" .. texte)
hook.Add("HUDPaint","AdvertisementBar",function()
	surface.SetDrawColor(Color(52,0,99))
	s = Lerp(FrameTime(),s,kek)
	surface.DrawRect(0,0,ScrW(),s)
	surface.SetFont("Coolvetica50")
	local tx = surface.GetTextSize(markupWithoutParse(texte))
textm.y = s-50
textm.x = ScrW() / 2 - tx / 2
matrix:SetTranslation(Vector(textm.x,textm.y))
cam.PushModelMatrix(matrix)
textm:Draw()
cam.PopModelMatrix()
end)
timer.Create("CloseAdvert",5,1,function()
kek = 0
timer.Create("RemoveHook",5,1,function()
hook.Remove("HUDPaint","AdvertisementBar")
end)
end)
end

net.Receive("TomkeAdvert",function()
local stryng = net.ReadString()
showAdvert(stryng:Trim())
end)