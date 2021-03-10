
local wojennastart = false
hook.Add("Think","godzinapolicyjna",function()
local date = (os.date("%H:%M:%S",os.time()))
if date == "19:59:00" and wojennastart == false then
wojennastart = true
startCountdown("Wprowadzam Stan Wojenny",60,function()
if(GetGlobalBool("wojenna",false)==false)then
RunConsoleCommand("ulx","wojenna")
end
wojennastart = false
end)
end
end)