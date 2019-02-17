TCore.avCache = TCore.avCache or {}
local cache = TCore.avCache
function TCore.GetAvatar(steamid, callback) -- BORROWED FROM https://github.com/PAC3-Server/gm-http-discordrelay/blob/master/lua/discordrelay/sv_discordrelay.lua
	local commid = util.SteamIDTo64(steamid)
	
	if cache[commid] then
		if callback then callback(cache[commid]) end
		return cache[commid]
	else
		http.Fetch("http://steamcommunity.com/profiles/" .. commid .. "?xml=1",
		function(content, size)
			local ret = content:match("<avatarFull><!%[CDATA%[(.-)%]%]></avatarFull>") or "http://i.imgur.com/ovW4MBM.png"
			cache[commid] = ret
			if callback then callback(ret) end
		end,
		function(err)
			TCore.msg("GetAvatar failed for:", steamid, err)
		end)
		return false
	end
end