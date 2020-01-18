local hostnames = {
  "( ͡° ͜ʖ ͡°)",
  "Masa addonów!",
  "Dla prawdziwych budowniczych!",
  "ACF/E2/SProps/PAC3",
  "Jedyny Taki W Swoim Rodzaju",
  "WHY U DDOS ME :("
  }
  util.AddNetworkString("HostnameChangerSync")
  local activehostname = ""
  local k = 1
  timer.Create("HostnameChanger",5,0,function()
    game.ConsoleCommand("hostname ![PL] Polski Sandbox - "..hostnames[k].."\n")
    activehostname = "![PL] Polski Sandbox - "..hostnames[k]
    net.Start("HostnameChangerSync")
    net.WriteString(activehostname)
    net.Broadcast()
    if k + 1 > #hostnames then
        k = 1
    else
        k = k + 1
    end
  end)

local connecting = {}
if (!istable(query)) then
	require("query")
end

query.EnableInfoDetour(true)

print("Detour enabled")
hook.Add("A2S_INFO", "reply", function(ip, port, info)
    --print("A2S_INFO from", ip, port)
    info.players =  #player.GetAll() + #connecting
    info.map = game.GetMap()
    return info
end)


gameevent.Listen("player_connect")
gameevent.Listen("player_disconnect")
hook.Add("player_connect", "AddToConnecting", function(data)
		table.insert(connecting,data.name)
end)
hook.Add("player_disconnect", "AddToConnecting", function(data)
		table.RemoveByValue(connecting,data.name)
end)
hook.Add("PlayerInitialSpawn","DeleteFromConnecting",function(ply)
  table.RemoveByValue(connecting,ply:Name())
end)

hook.Add("A2S_PLAYER", "reply", function(ip, port, info)
    local tbl = {   }
    for i,v in ipairs(player.GetAll()) do
      local score
      if cebulacoin then
        score = v:GetMoney()
      else
        score = 0
      end
      table.insert(tbl,{name=v:Name(),score=score,time=v:GetUTimeSessionTime()})
    end
     for i,v in ipairs(connecting) do
        table.insert(tbl,{name="[wchodzi] "..v,score=0,time=0})
      end
    return tbl
end)
