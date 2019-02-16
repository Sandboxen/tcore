if (!istable(GWSockets)) then
    require("gwsockets")
end
TCore.discordrelay = TCore.discordrelay or {}
local relay = TCore.discordrelay
local isConnected = false
local cache = {}

local function GetAvatar(steamid, callback) -- BORROWED FROM https://github.com/PAC3-Server/gm-http-discordrelay/blob/master/lua/discordrelay/sv_discordrelay.lua
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

local function emptyfunc()
end

function relay:StopConnection()
    if (self.socket) then
        self.socket.onConnected = emptyfunc
        self.socket.onMessage = emptyfunc
        self.socket:closeNow()
        self.socket.onDisconnected = emptyfunc
        self.socket = nil
    end
end

function relay:StartConnection()
    TCore.msg("Discord Relay Preparing!")
    self.socket = GWSockets.createWebSocket("ws://localhost:3721",true)
    self:PrepareHooks()
    self.socket:open()
end

function relay:SendMessage(msg)
    local tosend = msg
    tosend = util.TableToJSON(tosend)
    if self.socket then
        self.socket:write(tosend)
    end
end

local function onDisconnect(self)
    relay.socket = nil
    TCore.msg("Discord Relay Disconnected!")
    hook.Remove("PlayerSay","TCoreDiscordPlayerSay")
    TCore.msg("Relay Dead Retrying in 10 seconds")
    timer.Simple(10,function()
    relay:StopConnection()
    relay:StartConnection()
    end)
end

local function onConnect(self)
    TCore.msg("Discord Relay Connected!")
    isConnected = true
    hook.Add("PlayerSay","TCoreDiscordPlayerSay",function(ply,txt,team)
        GetAvatar(ply:SteamID(),function(ret)
            print(ret)
            relay:SendMessage({avatar_url=ret,content=txt,username=ply:Name()})
        end)
    end)
end

local function onMessage(self,msg)
    TCore.msg("Relay Msg ",msg)
    msg = util.JSONToTable(msg)
    local txt = msg.content
    local nick = msg.author[2]
    local data = nick .. ": " .. txt
    BroadcastLua([[chat.AddText(Color(114,137,218,255), "[Discord] ",Color(255,255,255,255),"]] .. data .. [[")]]) -- TEMPORARY
end

local function onErr(self,err)
    TCore.msg("Relay ERR ",err)
end

function relay:Identify()
    local tosend = {}
end

function relay:PrepareHooks()
    if (self.socket) then
       self.socket.onDisconnected = onDisconnect
       self.socket.onConnected = onConnect
       self.socket.onMessage = onMessage
    end
end
relay:StopConnection()
relay:StartConnection()