util.AddNetworkString("TB530Countdown")
function startCountdown(txt,time,cb)
net.Start("TB530Countdown")
net.WriteString("start")
net.WriteString(txt)
net.WriteString(tostring(time))
net.Broadcast()
timer.Simple(time,cb)
end
function abortCountdown()
  net.Start("TB530Countdown")
  net.WriteString("abort")
  net.Broadcast()
end
local midnightstart = false
hook.Add("Think","waitformidnight",function()
local date = (os.date("%H:%M:%S",os.time()))
if date == "2:58:00" and midnightstart == false then
midnighstart = true
startCountdown("RESTART SERWERA",120,function()
  midnightstart = false
end)
end
end)