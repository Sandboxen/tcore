hook.Add("OnPlayerChat","RanksTomek",function(ply,txt)
	if IsValid(ply) then
	overHeadText(txt,ply,false)
	if string.StartWith(txt,"tts:") then
	local tosay = string.sub(txt,5)
	sound.PlayURL("https://code.responsivevoice.org/getvoice.php?t=" .. tosay .. "&tl=pl-PL","3d",function(chan)
		if (IsValid(chan)) then
			chan:SetPos(ply:GetPos())
			chan:Play()
		end
	end)
	end
	if string.StartWith(txt,"dectts:") then
	local tosay = string.sub(txt,8)
	sound.PlayURL("http://talk.moustacheminer.com/api/gen/?dectalk=" .. tosay,"3d",function(chan)
		if (IsValid(chan)) then
			chan:SetPos(ply:GetPos())
			chan:Play()
		end
	end)
	end
end
end)