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


--BETTER PRINT
_G.oldprint = _G.oldprint or print
function _G.print(...)
	local tag = SERVER and "[TCoreSV]" or "[TCoreCL]" 
	local match = debug.getinfo(2).source:match("@addons/tcore/lua/tcore/(%w+)")
	if CLIENT and LocalPlayer() == GetTomek() then debug.Trace() end
	if match then
		tag = tag .. "[" .. match .. "]"

		if (SERVER) then
			MsgC(tag,unpack({...}))
			MsgC("\n")
		elseif (CLIENT) then
			MsgC(tag,unpack({...}))
			MsgC("\n")
		end
  	else
		_G.oldprint(...)
  	end
end