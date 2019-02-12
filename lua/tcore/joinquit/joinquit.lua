if SERVER then
	util.AddNetworkString("JoinQuitMessage")
	apikey = file.Read("apikey.txt","DATA") or ""
	hoursurl = "http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key="
	function CheckPlayTime( ply )
		ply1 = ply
		httpurl = "" .. hoursurl .. "" .. apikey .. "&steamid=" .. ply:SteamID64() .. "&format=json"
		http.Fetch( httpurl , function ( contents, size )
		local data = util.JSONToTable(contents)["response"]["games"]
		if (data) then
		for i,v in ipairs(data) do
			if v["appid"] == 4000 then
				local playtime = math.Round(v["playtime_forever"]/60)
				local data = {}
				data["name"] = ply:Nick()
				data["hours"] = playtime
				net.Start("JoinQuitMessage")
				net.WriteTable(data)
				net.WriteString("join")
				net.Broadcast()
		--BroadcastLua([[chat.AddText(Color(128,0,255),"[SERVER]",Color(230,230,230)," Gracz ",Color(255,0,0),"]]..ply:Nick()..[[",Color(230,230,230)," wszedł na serwer [",Color(255,0,0),"]]..playtime..[[H",Color(230,230,230),"]!")]])
		end
	end
	else
	local data = {}
	data["name"] = ply:Nick()
	net.Start("JoinQuitMessage")
	net.WriteTable(data)
	net.WriteString("join")
	net.Broadcast()
	end
	end)
end
function CheckError()
	print("Sprawdzanie Godzin ERROR")
end

gameevent.Listen("player_connect")
gameevent.Listen("player_disconnect")


    hook.Add("player_connect", "ShowConnect", function( data )
			net.Start("JoinQuitMessage")
			net.WriteTable(data)
			net.WriteString("connect")
			net.Broadcast()
    end)
    hook.Add("player_disconnect", "ShowDisconnect", function( data )
		net.Start("JoinQuitMessage")
		net.WriteTable(data)
		net.WriteString("disconnect")
		net.Broadcast()
    end)
    hook.Add("PlayerInitialSpawn","ShowSpawn",function(ply)
    	CheckPlayTime(ply)
    end)
else
    hook.Add("ChatText", "HideMSG", function( _, _, _, msg )
        if msg == "joinleave" then return true end
    end)
		net.Receive("JoinQuitMessage",function(_)
			local data = net.ReadTable()
			local messtype = net.ReadString()
			if messtype == "disconnect" then
				chat.AddText(Color(128,0,255),"[SERVER]",Color(230,230,230)," Gracz ",Color(255,0,0),data["name"],Color(230,230,230)," wyszedł z serwera! ["..data["reason"].."]")
			elseif messtype == "connect" then
				chat.AddText(Color(128,0,255),"[SERVER]",Color(230,230,230)," Gracz ",Color(255,0,0),data["name"],Color(230,230,230)," dołącza na serwer!")
			elseif messtype == "joinhours" then
					chat.AddText(Color(128,0,255),"[SERVER]",Color(230,230,230)," Gracz ",Color(255,0,0),data["name"],Color(230,230,230)," wszedł na serwer [",Color(255,0,0),data['hours'],"H",Color(230,230,230),"]!")
			elseif messtype == "join" then
						chat.AddText(Color(128,0,255),"[SERVER]",Color(230,230,230)," Gracz ",Color(255,0,0),data["name"],Color(230,230,230)," wszedł na serwer!")
			end
		end)
end
