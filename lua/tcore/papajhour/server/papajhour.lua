
local papyszmidnightstart = false
hook.Add("Think","waitforpapyszmidnight",function()
local date = (os.date("%H:%M:%S",os.time()))
if date == "21:36:50" and papyszmidnightstart == false then
papyszmidnightstart = true
startCountdown("Inbaaa",10,function()
if(GetGlobalBool("wojenna"))then  
RunConsoleCommand("ulx","wojenna")
end
--  BroadcastLua("runPapysz()")
  timer.Create("pshake",1/3,0,Shake)
  timer.Simple(60,function()
  timer.Remove("pshake")
  end)
  papyszmidnightstart = false
end)
end
end)
hook.Remove("Think","waitforpapyszmidnight")