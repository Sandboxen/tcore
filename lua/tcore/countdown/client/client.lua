local function startCountdown(text,time)
--local starttime = CurTime()
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

end)
end

local function abortCountdown()
hook.Remove("HUDPaint","TB530Countdown")
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