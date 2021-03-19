local papyszenable = CreateClientConVar("papaj_enable", "1")
local max = 30

surface.CreateFont("PapajHourInba", {
	font = "Tahoma",
	extended = true,
	size = 48,
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

function runPapysz()
	if not papyszenable:GetBool() then return end

	local song
	local papyszMats = {}
	local papyszPos = {}
	local papyszColor = {}

	for i = 1, max do
		papyszMats[i] = math.random(1, 10000000)

		// Preload
		timer.Simple(0.33 * i, function()
			GetURL("http://loading.tomekb530.me/papysz?test=" .. papyszMats[i], 100, 100)
		end)
	end

	sound.PlayURL("http://tomekb530.me/barka.mp3", "", function(st)
        if IsValid(st) then
            st:Play()
            song = st

            timer.Simple(60, function()
                st:Stop()
            end)
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
		if song and song:GetTime() > 17 then
			for i, v in ipairs(papyszPos) do
				local mat = GetURL("http://loading.tomekb530.me/papysz?test=" .. papyszMats[i], 100, 100)

				surface.SetMaterial(mat)
				surface.SetDrawColor(Color(255, 255, 255, 255))
				surface.DrawTexturedRect(v[1] + math.Rand(0, 10), v[2] + math.Rand(0, 10), 100, 100)
			end

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
		end

		timer.Simple(60, function()
			hook.Remove("HUDPaint", "PapajHour::HUD")
			timer.Remove("PapajHour::Updater")
		end)
	end)
end