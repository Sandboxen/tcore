local papyszenable = CreateClientConVar("papaj_enable","1")


local function getRandomPapysz(cb)
print("test")
pac.urltex.GetMaterialFromURL("http://loading.tomekb530.me/papysz?test="..math.Rand(0,10000),cb,true,"UnlitGeneric")
end

local WebMaterials = {}
local function GetURL(url, w, h, time)
	if !url or !w or !h then return Material("error") end
	if WebMaterials[url] then return WebMaterials[url] end
	local WebPanel = vgui.Create( "HTML" )
	WebPanel:SetAlpha( 0 )
	WebPanel:SetSize( tonumber(w), tonumber(h) )
	WebPanel:OpenURL( url )
	WebPanel.Paint = function(self)
		if !WebMaterials[url] and self:GetHTMLMaterial() then
			WebMaterials[url] = self:GetHTMLMaterial()
			self:Remove()
		end
	end
	timer.Simple( 1 or tonumber(time), function() if IsValid(WebPanel) then WebPanel:Remove() end end ) // In case we do not render
	return Material("error")
end


function runPapysz()
if true then return end
if not papyszenable:GetBool() then 
print("Papysz hour not enabled")
return 
end
local papyszMats = {}
local song
sound.PlayURL("http://tomekb530.me/barka.mp3","",function(st)
if IsValid(st) then
st:Play()
song = st
timer.Simple(60,function()
st:Stop()
end)
end
end)
for i=1,30 do
	papyszMats[i]=math.Rand(0,10000)
end
local papyrzpos = {}
local papyrzcol = {}
local ok = {0,0,0} 
hook.Add("HUDPaint","Papierz",function()
	if song and song:GetTime() > 17 then
		for i,v in ipairs(papyrzpos) do
			surface.SetMaterial(GetURL("http://loading.tomekb530.me/papysz?test="..papyszMats[i],100,100,120))
			surface.SetDrawColor(Color(255,255,255,255))
			surface.DrawTexturedRect(v[1]+math.Rand(0,10),v[2]+math.Rand(0,10),100,100)
		end
  		if song:GetTime()>40 then
		    surface.SetFont("CountdownFont")
		    for text=1,3 do
			    local col = papyrzcol[text]
			    local contrast = Color(math.abs(255-col.r),math.abs(255-col.g),math.abs(255-col.b),255)
			    local cw = surface.GetTextSize("Inbaaaa")
			    surface.SetTextColor(contrast)
			    surface.SetTextPos(papyrzpos[text][1],papyrzpos[text][2])
			    surface.DrawText("Inbaaaa")
			    surface.SetTextColor(col)
			    surface.SetTextPos(papyrzpos[text][1],papyrzpos[text][2])
			    surface.DrawText("Inbaaaa")
		    end
		end
	end
end)
timer.Create("Papysz",1/3,0,function()
	local w, h = ScrW() - 300, ScrH()
	for i=1,10 do
		papyrzpos[i] = {math.random(0, w), math.random(0, h)}
    papyrzcol[i] = Color(math.random(0,255),math.random(0,255),math.random(0,255))
	end
end)
timer.Simple(60,function()
hook.Remove("HUDPaint","Papierz")
timer.Remove("Papysz")
end)
end
