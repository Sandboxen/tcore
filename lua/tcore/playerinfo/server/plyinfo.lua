util.AddNetworkString("TCorePlyInfo")

function checkFamilyShare(target)
    http.Fetch(
		string.format("http://api.steampowered.com/IPlayerService/IsPlayingSharedGame/v0001/?key=%s&format=json&steamid=%s&appid_playing=4000",
			util.GetApiKey(),
			target:SteamID64()
		),

		function(body)
			--Put the http response into a table.
			local body = util.JSONToTable(body)

			--If the response does not contain the following table items.
			if not body or not body.response or not body.response.lender_steamid then
				error(string.format("FamilySharing: Invalid Steam API response for %s | %s\n", target:Nick(), target:SteamID()))
			end

			--Set the lender to be the lender in our body response table.
			local lender = body.response.lender_steamid
			--If the lender is not 0 (Would contain SteamID64). Lender will only ever == 0 if the account owns the game.
			if lender ~= "0" then
				--Lets ban the owners account too.
				
			end
		end,

		function(code)
			error(string.format("FamilySharing: Failed API call for %s | %s (Error: %s)\n", target:Nick(), target:SteamID(), code))
		end
		)
end


net.Receive("TCorePlyInfo",function(_,ply)
    local who = net.ReadEntity()
    local info = {}
    info.pcountall = 0
    info.pcountparent = 0
    for i,v in ipairs(ents.GetAll()) do
        if(IsValid(v) and v.CPPIGetOwner and v:CPPIGetOwner() == who) then
            if(IsValid(v:GetParent()))then
                info.pcountparent=info.pcountparent+1
            end
            info.pcountall=info.pcountall+1
        end
    end
    info.model = ply:GetModel()
end)