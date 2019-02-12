local ply = FindMetaTable("Player")
function ply:IsTomek()
return self:SteamID64() == "76561198235918302"
end
function GetTomek()
for i,v in ipairs(player.GetAll()) do
if v:IsTomek() then
	return v
end
end
return nil
end

function FindPlayer(info)
	local pls = player.GetAll()

	for k, v in pairs(pls) do
		if v:SteamID64() == info then
			return v
		end
	end

	return nil
end
