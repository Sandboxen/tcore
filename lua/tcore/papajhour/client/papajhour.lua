local papyszenable = CreateClientConVar("papaj_enable", "1")
local max = 10
local papyszPos = {}
local papyszMats = {}
local song


surface.CreateFont("PapajHourInba", {
	font = "Roboto",
	extended = true,
	size = 50,
	weight = 400,
	antialias = true
})

local WebMaterials = {}
local function GetURL(url, w, h)
    if not url or not w or not h then return Material("error") end
    if WebMaterials[url] then return WebMaterials[url] end

    local WebPanel = vgui.Create("HTML")
    WebPanel:SetAlpha(0)
    WebPanel:SetSize(tonumber(w), tonumber(h))
	WebPanel:SetHTML([[<html>
		<head>
			<style>
				* { overflow: hidden; }
				body { margin: 0; padding: 0; background: transparent; }
			</style>
		</head>
		<body>
			<img src="]] .. url .. [[" width="100px" height="100px">
		</body>
	</html>]])

    WebPanel.Paint = function(self)
        if not WebMaterials[url] and self:GetHTMLMaterial() then
            WebMaterials[url] = self:GetHTMLMaterial()
        end
    end

    return Material("error")
end



for i = 1, max do
	papyszMats[i] = http.Fetch("http://gmodback.tomekb530.me/papysz?test=" .. i, function(body)
		papyszMats[i] = body
	end)

	// Preload
	timer.Simple(0.33 * i, function()
		GetURL(papyszMats[i], 100, 100)
	end)
end


local timedtext = {
	[0] = "",
	[1.7] = "Siemanko",
	[7.4] = "Czy jesteście gotowi na...",
	[13.3] = "INBE?",
	[16.2] = ""
}

local timedeffects = {
	[0] = function()
		
	end,
	[16.2] = function()
		local scrw = ScrW()
		local scrh = ScrH()
		local color = HSVToColor(song:GetTime()*80,1,1)
		color.a = 20
		surface.SetDrawColor(color)
		surface.DrawRect(0,0,scrw,scrh)
		--[[local mat = GetURL("http://tomekb530.me/rzulta.png", 256,256)
		surface.SetMaterial(mat)
		surface.SetDrawColor(Color(255, 255, 255, 255))
		local size = 250 + math.sin(song:GetTime()*10)*50
		surface.DrawTexturedRect(scrw/2-size/2,scrh/2-size/2,size,size)]]--
	end,

	[28] = function()
		for i, v in ipairs(papyszPos) do
			local mat = GetURL(papyszMats[i], 100, 100)
			
			surface.SetMaterial(mat)
			surface.SetDrawColor(Color(255, 255, 255, 255))
			surface.DrawTexturedRect(v[1] + math.Rand(0, 10), v[2] + math.Rand(0, 10), 256, 256)
		end
	end,
	[50] = function()
		local fft = {}
		local num = song:FFT(fft,FFT_1024)
		local hcalc = ScrH() / num * 2
		local wcalc = ScrW()
		for i=1,num do
			surface.SetDrawColor(HSVToColor(360/num*i,1,1))
			surface.DrawRect(ScrW()-wcalc*fft[i],hcalc*i,wcalc*fft[i],hcalc)
			surface.SetDrawColor(HSVToColor(360/num*i,1,1))
			surface.DrawRect(0,hcalc*i,wcalc*fft[i],hcalc)
		end
	end
}


local function getNearestTimedText(time)
	local nearest = 0

	for k, v in pairs(timedtext) do
		if k < time and k > nearest then
			nearest = k
		end
	end

	return timedtext[nearest]
end

local function getEffects(time)
	local effectsFuncs = {}

	for k, v in pairs(timedeffects) do
		if k < time then
			table.insert(effectsFuncs, v)
		end
	end

	return effectsFuncs
end


function stopPapysz()
	hook.Remove("HUDPaint", "PapajHour::HUD")
	timer.Remove("PapajHour::Updater")
	timer.Remove("PapajHour::Remover")
	if song then
		song:Stop()
	end
end

function runPapysz()
	if not papyszenable:GetBool() then return end

	local papyszColor = {}

	timer.Create("PapajHour::Remover",60,1, function()
		stopPapysz()
	end)

	sound.PlayURL("http://tomekb530.me/caramell.mp3", "", function(st)
        if IsValid(st) then
            st:Play()
            song = st

            
        end
    end)

	timer.Create("PapajHour::Updater", 1/3, 0, function()
		local w, h = ScrW() - 300, ScrH() - 100
		
		for i = 1, max do
			papyszPos[i] = {math.random(0, w), math.random(0, h)}
	
			papyszColor[i] = Color(math.random(0, 255), math.random(0, 255), math.random(0, 255))
		end
	end)

	hook.Add("HUDPaint", "PapajHour::HUD", function()
		if IsValid(song) then
			--print(song:GetTime())
			local text = getNearestTimedText(song:GetTime())
			surface.SetFont("PapajHourInba")
			local textWidth,textHeight = surface.GetTextSize(text)
			draw.SimpleTextOutlined(text, "PapajHourInba", ScrW() / 2, ScrH() / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))

			local effectsFunc = getEffects(song:GetTime())
			for k, v in pairs(effectsFunc) do
				v()
			end
		end





		--[[if song and song:GetTime() > 17 then
			

			if song:GetTime() > 40 then
				surface.SetFont("PapajHourInba")

				for textID = 1, 3 do
					local textColor = papyszColor[textID]
					local textContrast = Color(math.abs(255 - textColor.r), math.abs(255 - textColor.g), math.abs(255 - textColor.b), 255)
					local textWidth = surface.GetTextSize("Inbaaaa")

					surface.SetTextColor(textContrast)
					surface.SetTextPos(papyszPos[textID][1] - textWidth / 2, papyszPos[textID][2])
					surface.DrawText("Inbaaaa")
					surface.SetTextColor(textColor)
					surface.SetTextPos(papyszPos[textID][1] - textWidth / 2, papyszPos[textID][2])
					surface.DrawText("Inbaaaa")
				end
			end
		end]]
	end)
end