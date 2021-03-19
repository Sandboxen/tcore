hook.Add("Think", "PapajHour::Wait", function()
	local date = (os.date("%H:%M:%S", os.time()))

	if date == "21:36:50" then
			hook.Remove("Think", "PapajHour::Wait")

			startCountdown("Inbaaa", 10, function()
					if (GetGlobalBool("wojenna")) then
							RunConsoleCommand("ulx", "wojenna")
					end

					BroadcastLua("runPapysz()")
			end)
	end
end)