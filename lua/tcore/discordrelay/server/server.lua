TCore.discordrelay = TCore.discordrelay or {}
local relay = TCore.discordrelay
TCore.discordrelay.commands = {}
local commands = TCore.discordrelay.commands
local isConnected = false
local cache = TCore.avCache
local GetAvatar = TCore.GetAvatar
local function emptyfunc()
end

local charset = {}

-- qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890
for i = 48,  57 do table.insert(charset, string.char(i)) end
for i = 65,  90 do table.insert(charset, string.char(i)) end
for i = 97, 122 do table.insert(charset, string.char(i)) end

local function stringrandom(length)
  math.randomseed(os.time())

  if length > 0 then
    return stringrandom(length - 1) .. charset[math.random(1, #charset)]
  else
    return ""
  end
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

function relay:SendMessage(msg)
    local tosend = msg
    tosend = util.TableToJSON(tosend)
    http.Post("http://localhost:3721/sendmsg", {data=tosend})
end
function fetchMsgs()
local tosend = {
    limit = 3,
    around = around or 0
}
tosend = util.TableToJSON(tosend)
HTTP{
success=function(_,bd)--uber anti cache
local data = util.JSONToTable(bd)
for i,v in ipairs(data) do
onMessage(nil,v)
end
end,
method="GET",
url="http://localhost:3721/getmsg"
}

end
timer.Create("TCoreDiscordFetchMsgs",1.5,0,fetchMsgs)

gameevent.Listen("player_connect")
gameevent.Listen("player_disconnect")

local function onConnect(self)
    TCore.msg("Discord Relay Connected!")
    isConnected = true
end



local function onErr(self,err)
    TCore.msg("Relay ERR ",err)
end

hook.Add("PlayerSay","TCoreDiscordPlayerSay",function(ply,txt,team)
    GetAvatar(ply:SteamID(),function(ret)
        --print(team)
        if team == CHATMODE_DEFAULT or team == false then
            relay:SendMessage({avatar_url=ret,content=txt,username=ply:Name()})
        end
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
            description = "Wyszedł z serwera. \n("..data.reason..")",
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

local function prepareEmbed(ply)
	
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
			return {
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

hook.Add("TCoreRelayMessage","TCoreRelayCmds",function(msg,author)
    for i,v in pairs(commands) do
        if string.StartWith(msg,"!"..i) then
            local data = string.sub(msg,string.len("!"..i)+2)
            local ok,why = pcall(v,author,data)
            if not ok then
                relay:SendMessage({content="Command ERR:\n```"..why.."```"})
            end
            return true
        end
    end
end)

commands["status"] = function(author,data)
local message = 1
        local plytabs = {}
		local amount = player.GetCount()
        if amount == 0 then
            relay:SendMessage({content="**Nazwa:** " .. GetHostName() .. "\n**Czas Online:** " .. string.NiceTime(CurTime()) .. "\n**Mapa:** " .. game.GetMap() .. "\n**Gracze:** ".. #player.GetAll() .. "/" .. game.MaxPlayers(),
                embeds = {
					[1] = {
						["title"] = "Status:",
						["description"] = "Nie ma graczy na serwerze :(...\nChcesz dołączyć? Kliknij ten link: steam://connect/"..game.GetIPAddress(),
						["type"] = "rich",
						["color"] = 0x555555
					}
				}
                })
            return true
        end
        for i,ply in pairs(player.GetAll()) do
            plytabs[message] = plytabs[message] or {}
            table.insert(plytabs[message],ply)
            if (#plytabs[message] == 10) then
                message = message + 1
            end
        end
        for i,v in ipairs(plytabs) do
            local embeds = {}
            for i,v in ipairs(v) do
                table.insert(embeds,prepareEmbed(v))
            end
            if i == 1 then
                relay:SendMessage({content="**Nazwa:** " .. GetHostName() .. "\n**Czas Online:** " .. string.NiceTime(CurTime()) .. "\n**Mapa:** " .. game.GetMap() .. "\n**Gracze:** ".. #player.GetAll() .. "/" .. game.MaxPlayers(),
                embeds = embeds
                })
            else
                timer.Simple(0.1,function()
                relay:SendMessage({content="Dalsza czesc graczy",
                embeds = embeds
                })
                end)
            end
        end
end


commands["rcon"] = function(author,data)
if author[3] and (accessCheck(author[3],262158797424820224) or accessCheck(author[3],257532593145118721) ) then
                data = string.Split(data," ")
                RunConsoleCommand(unpack(data))
                relay:SendMessage({content=":ok_hand:"})
            else
                relay:SendMessage({content=":lock:"})
            end
end