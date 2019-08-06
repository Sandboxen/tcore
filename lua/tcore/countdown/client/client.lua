local countdown = false
	local ssound
local function startCountdown(text,time)
countdown = true
--local starttime = CurTime()
 --https://github.com/roboderpy/DPP/blob/master/lua/dpp/cl_init.lua
local popupsPos = {}
local popupsColor = {}
	local nextPopup = 0
	local nextStress = 0
	local lastNumber = 0

    if not ssound then
			ssound = CreateSound(LocalPlayer(), Sound("ambient/alarms/siren.wav"))
		end
    ssound:Play()
	local popups = {}
  local cleanupPopups = {
		"SZYBCIEJ!", "PRZYSPIESZ!", "NIE ZDAZYSZ!",
		"SZYBKO!", "JEZU ALE JESTES WOLNY!", "ZAPISALES WSZYSTKO?!",
		"NAPEWNO ZAPISALES WSZYSTKO?!", "OMG!", "O KURWA!",
		"ZAPOMNIALES CZEGOS!", "ZAPISZ ZAPISZ ZAPISZ","A NAPEWNO ZAPISALES?",
    "[PANIKA INTENSIFIES]","KURWA SZYBCIEJ","krzyk.mp3"
	}
  local stressSounds = {
		Sound("vo/ravenholm/exit_hurry.wav"), Sound("vo/npc/Barney/ba_hurryup.wav"),
		Sound("vo/Citadel/al_hurrymossman02.wav"), Sound("vo/Streetwar/Alyx_gate/al_hurry.wav"),
		Sound("vo/ravenholm/monk_death07.wav"), Sound("vo/coast/odessa/male01/nlo_cubdeath02.wav")
	}

	local numberSounds = {
		Sound("npc/overwatch/radiovoice/one.wav"), Sound("npc/overwatch/radiovoice/two.wav"),
		Sound("npc/overwatch/radiovoice/three.wav"), Sound("npc/overwatch/radiovoice/four.wav"),
		Sound("npc/overwatch/radiovoice/five.wav"), Sound("npc/overwatch/radiovoice/six.wav"),
		Sound("npc/overwatch/radiovoice/seven.wav"), Sound("npc/overwatch/radiovoice/eight.wav"),
		Sound("npc/overwatch/radiovoice/nine.wav")
	}
local endtime = CurTime() + time
local hidetime = endtime + 1
surface.CreateFont("CountdownFont",{
font = "Roboto",
size = 50,
})
hook.Add("HUDPaint","TB530Countdown",function()
  local w = ScrW() / 2
  local h = 40
  local timeleft = endtime - CurTime()
  local howmuch = timeleft / time
  if CurTime() > hidetime then
    hook.Remove("HUDPaint","TB530Countdown")
    hook.Remove("Think","TB530Countdown")
    if ssound then ssound:Stop() end
  end
  surface.SetDrawColor(Color(255,0,0,255))
  surface.DrawRect(w / 2,ScrH() / 2-200,howmuch * w,h)
  surface.SetDrawColor(Color(0,0,0,100))
  surface.DrawRect(w / 2,ScrH() / 2-200 + h / 2,howmuch * w,h / 2)
  surface.SetDrawColor(Color(0,0,0,255))
  surface.DrawOutlinedRect(w / 2,ScrH() / 2-200,w,h)

  surface.SetFont("CountdownFont")
  local tw = surface.GetTextSize(text)
  surface.SetTextColor(Color(0,0,0,255))
  surface.SetTextPos(ScrW() / 2-tw / 2 + 2,ScrH() / 2-250 + 2)
  surface.DrawText(text)
  surface.SetTextColor(Color(255,0,0,255))
  surface.SetTextPos(ScrW() / 2-tw / 2,ScrH() / 2-250)
  surface.DrawText(text)

  local clock = string.FormattedTime(math.Clamp(timeleft,0,math.huge),"%02i:%02i:%02i")
    surface.SetFont("CountdownFont")
  local cw = surface.GetTextSize(clock)
  surface.SetTextColor(Color(0,0,0,255))
  surface.SetTextPos(ScrW() / 2-cw / 2 + 2,ScrH() / 2-130)
  surface.DrawText(clock)
  surface.SetTextColor(Color(255,255,255,255))
  surface.SetTextPos(ScrW() / 2-cw / 2,ScrH() / 2-130)
  surface.DrawText(clock)
  for i = 1, 6 do
			if popupsPos[i] then
        surface.SetTextColor(popupsColor[i])
				surface.SetTextPos(popupsPos[i][1]+math.Rand(1,30), popupsPos[i][2]+math.Rand(1,30))
				surface.DrawText(popups[i])
			end
		end

end)
hook.Add("Think","TB530Countdown",function()


		local time = RealTime()
    local timeleft = endtime - CurTime()
    local num = math.floor(timeleft)
    if(numberSounds[num] ~= nil and CurTime() - lastNumber > 1) then
				lastNumber = CurTime()
				LocalPlayer():EmitSound(numberSounds[num], 511, 100)
			end
		if nextStress < time then
			nextStress = time + math.random(0.5, 1.25)
			LocalPlayer():EmitSound(stressSounds[math.random(1, #stressSounds)], 60,math.floor(math.Rand(100,255)), 0.7)
		end

		if nextPopup < time then
			nextPopup = time + 0.5
			local w, h = ScrW() - 300, ScrH()

			for i = 1, 6 do
				popups[i] = cleanupPopups[math.random(1, #cleanupPopups)]
				popupsPos[i] = {math.random(0, w), math.random(0, h)}
        popupsColor[i] = Color(math.random(0,255),math.random(0,255),math.random(0,255))
			end
		end
end)
end

local function abortCountdown()
hook.Remove("HUDPaint","TB530Countdown")
hook.Remove("Think","TB530Countdown")
if ssound then ssound:Stop() end
end

net.Receive("TB530Countdown",function()
local func = net.ReadString()
local txt = net.ReadString()
local time = tonumber(net.ReadString())
if func == "abort" then
abortCountdown()
elseif func == "start" and time > 0 then
startCountdown(txt,time)
end
end)