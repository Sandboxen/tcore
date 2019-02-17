if (!istable(GWSockets)) then
    require("gwsockets")
end
TCore.discordrelay = TCore.discordrelay or {}
local relay = TCore.discordrelay
local isConnected = false
local cache = TCore.avCache
local GetAvatar = TCore.GetAvatar
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
    TCore.msg("Relay Dead Retrying in 10 seconds")
    timer.Simple(10,function()
    relay:StopConnection()
    relay:StartConnection()
    end)
end

gameevent.Listen("player_connect")
gameevent.Listen("player_disconnect")

local function onConnect(self)
    TCore.msg("Discord Relay Connected!")
    isConnected = true
end

local function onMessage(self,msg)
    TCore.msg("Relay Msg ",msg)
    msg = util.JSONToTable(msg)
    local txt = msg.content
    local nick = msg.author[2]
    local data = nick .. ": " .. txt
    local hk = hook.Run("TCoreRelayMessage",msg.content,msg.author)
    if !hk then
        --print('bc')
        BroadcastLua([[chat.AddText(Color(114,137,218,255), "[Discord] ",Color(255,255,255,255),"]] .. data .. [[")]]) -- TEMPORARY
    end
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

hook.Add("PlayerSay","TCoreDiscordPlayerSay",function(ply,txt,team)
    GetAvatar(ply:SteamID(),function(ret)
        --print(ret)
        relay:SendMessage({avatar_url=ret,content=txt,username=ply:Name()})
    end)
end)
hook.Add("player_connect","TCoreDiscordRelayPlayerConnect",function(data)
    local nick = data.name
    local sid = data.networkid
    GetAvatar(sid,function(ret)
        --print(ret)
        local embed = {
            description = "Wchodzi na serwer.",
            color = 255,
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
            author = {
                name = nick,
                url = "http://steamcommunity.com/profiles/" .. util.SteamIDTo64(sid),
                icon_url = ret
            }
        }
        relay:SendMessage({avatar_url="https://cdn.discordapp.com/avatars/431413205605023755/f06c3a070adf795b540b1499d009ea71.png?size=1024",username="Serwer",embeds={[1]=embed}})
    end)
end)
hook.Add("PlayerInitialSpawn","TCoreDiscordRelayPlayerConnect",function(ply)
    local nick = ply:Name()
    local sid = ply:SteamID()
    GetAvatar(sid,function(ret)
        --print(ret)
        local embed = {
            description = "Wszedł na serwer.",
            color = 65280,
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
            author = {
                name = nick,
                url = "http://steamcommunity.com/profiles/" .. util.SteamIDTo64(sid),
                icon_url = ret
            }
        }
        relay:SendMessage({avatar_url="https://cdn.discordapp.com/avatars/431413205605023755/f06c3a070adf795b540b1499d009ea71.png?size=1024",username="Serwer",embeds={[1]=embed}})
    end)
end)
hook.Add("player_disconnect","TCoreDiscordRelayPlayerConnect",function(data)
    local nick = data.name
    local sid = data.networkid
    GetAvatar(sid,function(ret)
        --print(ret)
        local embed = {
            description = "Wyszedł z serwera.",
            color = 16711680,
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
            author = {
                name = nick,
                url = "http://steamcommunity.com/profiles/" .. util.SteamIDTo64(sid),
                icon_url = ret
            }
        }
        relay:SendMessage({avatar_url="https://cdn.discordapp.com/avatars/431413205605023755/f06c3a070adf795b540b1499d009ea71.png?size=1024",username="Serwer",embeds={[1]=embed}})
    end)
end)

local function accessCheck(roles,role)
    for i,v in ipairs(roles) do
        if v == role or tonumber(v) == role or tonumber(v) == tonumber(role) then
            return true
        end
    end
    return false
end

hook.Add("TCoreRelayMessage","TCoreRelayCmds",function(msg,author)
    if string.StartWith(msg,"!") then
        local cmd = string.sub(msg, 2)
        if string.StartWith(cmd,"status") then
        local embeds = {}
		local amount = player.GetCount()
		for i,ply in pairs(player.GetAll()) do
			local commid = util.SteamIDTo64(ply:SteamID()) -- move to player meta?
			local godmode = ply:GetInfo("cl_godmode") or 1
			local emojis = {
				["🚗"] = ply:InVehicle(),
				["⌨"] = ply:IsTyping(),
				["🔌"] = ply:IsTimingOut(),
				["❄"] = ply:IsFrozen(),
				["🤖"] = ply:IsBot(),
				["🛡"] = ply:IsAdmin(),
				["👍"] = ply:IsPlayingTaunt(),
				["⛩"] = ply:HasGodMode() or (tonumber(godmode) and tonumber(godmode) > 0) or godmode ~= "0",
				["💡"] = ply:FlashlightIsOn(),
				["💀"] = not ply:Alive(),
				["🕴"] = ply:GetMoveType() == MOVETYPE_NOCLIP,
				["💤"] = ply:IsAFK(),
				--[""] = ply:IsMuted(),
				--[""] = ply:IsSpeaking(),
			}
			local emojistr = ""
			for emoji, yes in pairs(emojis) do
				if yes then
					emojistr = " " .. emojistr .. emoji
				end
			end
			embeds[i] = {
				["author"] = {
					["name"] = string.gsub(ply:Nick(),"<.->","") .. (emojistr and ( " [" .. emojistr .. " ]") or ""),
					["icon_url"] = cache[commid] or "https://i.imgur.com/ovW4MBM.png",
					["url"] = "http://steamcommunity.com/profiles/" .. commid,

				},
				["fields"] = {
					[1] = {
						["name"] = ":timer:",
						["value"] = string.NiceTime(ply:TimeConnected()),
						["inline"] = true

					},
					[2] = {
						["name"] = ":ping_pong:",
						["value"] = tostring(ply:Ping()),
						["inline"] = true
					},
					[3] = {
						["name"] = ":clock:",
						["value"] = string.NiceTime(ply:GetUTimeTotalTime()) or "???",
						["inline"] = true
					}
				},
				["color"] = ply:IsAFK() and 0xccc000 or (ply:Alive() and 0x008000 or 0x700000)
			}
            end
            relay:SendMessage({content="**Nazwa:** " .. GetHostName() .. "\n**Czas Online:** " .. string.NiceTime(CurTime()) .. "\n**Mapa:** " .. game.GetMap() .. "\n**Gracze:** ".. #player.GetAll() .. "/" .. game.MaxPlayers(),
            embeds = embeds
            })
        elseif string.StartWith(cmd,"rcon") then
            if author[3] and (accessCheck(author[3],262158797424820224) or accessCheck(author[3],257532593145118721) ) then
                local data = string.sub(cmd,6)
                data = string.Split(data," ")
                RunConsoleCommand(unpack(data))
                relay:SendMessage({content=":ok_hand:"})
            else
                relay:SendMessage({content=":lock:"})
            end
        end
        return true
    end
end)