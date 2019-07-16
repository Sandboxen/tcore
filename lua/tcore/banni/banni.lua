--from https://github.com/Re-Dream/misc/blob/master/lua/autorun/banni.lua

banni = {}
local tag = "banni"

if CLIENT then
	local function emitsound(path,pitch)
		sound.PlayFile("sound/"..path,"",function(station)
			station:SetPlaybackRate(pitch)
			station:Play()
			hook.Add("Think", "EMITSOUNDSSOSS", function()
				station:SetVolume(system.HasFocus() and 1 or 0)
			end)
		end)
	end

	net.Receive(tag, function()
		local tbl = net.ReadTable()
		local sasdsa = player.GetBySteamID( tbl.steamid )
		local assdsa = player.GetBySteamID( tbl.who )
		local a = {
			assdsa and assdsa:Nick() or tbl.who
		}

		if(tbl.banned == true) then
			table.insert(a, Color(237,67,55))
			table.insert(a, " banned ")
			table.insert(a, Color(255,255,255))
			table.insert(a, sasdsa and sasdsa:Nick() or tbl.steamid)
			table.insert(a, " until "..os.date("%c", tbl.startedat+tbl.time)..", ")
		else
			table.insert(a, Color(75,181,67))
			table.insert(a, " unbanned ")
			table.insert(a, Color(255,255,255))
			table.insert(a, sasdsa and sasdsa:Nick() or tbl.steamid)
			table.insert(a, ",")
		end

		table.insert(a, " reason: ")
		table.insert(a, tbl.reason)

		chat.AddText(Color(255,255,255), a[1], a[2], a[3], a[4], a[5], a[2], a[6], Color(135,206,250), a[7], Color(255,255,255), a[8])

		if(tbl.banned == true) then
			emitsound("ambient/alarms/apc_alarm_pass1.wav", 1.25)
			surface.PlaySound("buttons/button6.wav")
		else
			surface.PlaySound("buttons/button5.wav")
		end

		if(sasdsa ~= false) then
			sasdsa.banni = tbl.banned
		end
	end)

	net.Receive(tag.."_bannedppl", function()
		local tbl = net.ReadTable()

		for k,v in pairs(tbl) do
			local ply = player.GetBySteamID(v.steamid)

			if(ply ~= false) then
				ply.banni = true
			end
		end
	end)

	hook.Add("PrePlayerDraw", tag, function(ply)
		if ply.banni then
			render.SetMaterial(Material("debug/debugwhite"))
			render.SuppressEngineLighting(true)
		end
	end)

	hook.Add("PostPlayerDraw", tag, function(ply)
		if ply.banni then
			render.SuppressEngineLighting(false)
		end
	end)

	hook.Add("Think", tag, function()
		for k,v in pairs(player.GetAll()) do
			if(v.banni == true and v:GetColor() ~= Color(255,0,0)) then
				v.origmat = v:GetMaterial()
				v:SetMaterial( "models/debug/debugwhite" )
				v:SetColor(Color(255,0,0))
				if v.buildmode != false then
				v.buildmode = false
				v:SetNWBool("_Kyle_Buildmode",false)
				end
			elseif v.banni == false and v:GetColor() ~= Color(255,255,255) then
				v:SetMaterial( v.origmat )
				v:SetColor(Color(255,255,255))
			end
		end
	end)

	hook.Add("OnPlayerChat", tag, function(ply,txt)
		if(ply.banni) then
			for k,v in pairs(ents.FindInSphere(LocalPlayer():GetPos(),256)) do
				if(v == LocalPlayer()) then
					chat.AddText(Color(237,67,55), "[BANNI] ", team.GetColor(ply:Team()), ply:Nick(), Color(255,255,255), ": ", txt)
				end
			end
			return false
		end
	end)
elseif SERVER then
	util.AddNetworkString(tag)
	util.AddNetworkString(tag.."_bannedppl")

	local CMoveData = FindMetaTable( "CMoveData" )

	function CMoveData:RemoveKeys( keys )
		-- Using bitwise operations to clear the key bits.
		local newbuttons = bit.band( self:GetButtons(), bit.bnot( keys ) )
		self:SetButtons( newbuttons )
	end

	hook.Add( "SetupMove", "jooj", function( ply, mvd, cmd )
		if(ply.banni) then
			if mvd:KeyDown( IN_JUMP ) then
				mvd:RemoveKeys( IN_JUMP )
			end
		end
	end )

	local hookss = {}

	hookss.ShutDown = function()
		file.Write("banni.txt", util.TableToJSON(banni.bannedppl))
	end

	hookss.Think = function()
		for k,v in pairs(banni.bannedppl) do
			if(os.time() > (v.startedat + v.time)) then
				banni.unban("Server",v.steamid,"Ban time expired.")
			end
		end
	end

	hookss.PlayerInitialSpawn = function(ply)
		local ass = {}

		for k,v in pairs(banni.bannedppl) do
			if(v.steamid == ply:SteamID()) then
				ply.banni = true
				ply:StripWeapons()
				ply:SetRunSpeed(ply:GetWalkSpeed())
				ply:SetSuperJumpMultiplier(1)
				ply:SetJumpPower(0)

				ass = v
				ass.banned = true

				banni.net(ass)
			end
		end

		net.Start(tag.."_bannedppl")
		net.WriteTable(banni.bannedppl)
		net.Send(ply)
	end

	hookss.PlayerShouldTakeDamage = function(ply)
		if (ply.banni == true) then 
			return true
		end
	end

	hookss.PlayerDeath = function(ply)
		if (ply.banni == true) then
			timer.Simple(0.5, function()
				if ply:Alive() then return end
				local oldPos, oldAng = ply:GetPos(), ply:EyeAngles()
				ply:Spawn()
				ply:SetPos(oldPos)
				ply:SetEyeAngles(oldAng)
			end)
		end
	end

	hookss.PlayerSpawn = function(ply)
		if(ply.banni == true) then
			timer.Simple(0.5, function()
				ply:SetRunSpeed(ply:GetWalkSpeed())
				ply:SetSuperJumpMultiplier(1)
				ply:SetJumpPower(0)
				ply.buildmode = false
				ply:SetNWBool("_Kyle_Buildmode",false)
			end)
			ply:StripWeapons()
		end
	end

	hookss.PhysgunPickup = function(ply,ent)
		if(ent:IsPlayer() and ent.banni) then
			ent:SetMoveType(MOVETYPE_NONE)
			return true
		end
	end

	hookss.PhysgunDrop = function(ply,ent)
		if(ent:IsPlayer() and ent.banni) then
			ent:SetMoveType(MOVETYPE_NONE)
		end
	end

	hookss.PlayerCanPickupWeapon = function (ply)
		if(ply.banni == true) then
			return false
		end
	end

	hookss.MingebanCommand = function(caller)
		if(caller.banni) then return false,"You cannot execute command while you're banned!" end
	end

	hookss.pac_WearOutfit = function(owner)
		if(owner.banni) then return false,"owner is a banned person" end
	end

	hookss.PlayerNoClip = function(ply)
		if(ply.banni) then return false end
	end

	local args = {
		"SWEP",
		"SENT",
		"Vehicle",
		"NPC",
		"Effect",
		"Prop",
		"Ragdoll"
	}

	for k,v in pairs(args) do
		hookss["PlayerSpawn"..v] = function(ply)
			if(ply.banni) then
				return false
			end
		end
	end

	for k,v in pairs(hookss) do
		hook.Add(k, tag, v)
	end

	banni.bannedppl = util.JSONToTable(file.Read("banni.txt", "DATA") or "{}")
	banni.net = function(tbl)
		net.Start(tag)
		net.WriteTable(tbl)
		net.Broadcast()
	end

	banni.ban = function(whosteamid,steamid,time,reason)
		if(time == nil or steamid == nil or reason == nil or whosteamid == nil) then
			return "fuck no, a nil value"
		end

		local key = -1

		for k,v in pairs(banni.bannedppl) do
			if(v.steamid == steamid) then
				key = k
			end
		end

		if(key ~= -1) then return "player is already banned" end

		local food = (type(steamid) == "table") and steamid or {
			time = time,
			steamid = steamid,
			startedat = os.time(),
			banned = true,
			who = whosteamid,
			reason = reason
		}

		banni.net(food)

		food.banned = nil

		table.insert(banni.bannedppl, food)

		local ply = player.GetBySteamID(steamid)

		if(ply ~= false) then
			ply:ConCommand("gmod_cleanup")
			ply:ConCommand("pac_clear_parts")

			if ply:GetMoveType() == MOVETYPE_NOCLIP then
				ply:SetMoveType(MOVETYPE_WALK)
			end

			ply.banni = true

			ply:StripWeapons()
			ply:SetRunSpeed(ply:GetWalkSpeed())
			ply:SetSuperJumpMultiplier(1)
			ply:SetJumpPower(0)
		end
	end

	banni.unban = function(whosteamid, steamid,reason)
		if(steamid == nil or reason == nil or whosteamid == nil) then
			return "fuck no, a nil value"
		end

		local key = -1

		for k,v in pairs(banni.bannedppl) do
			if(v.steamid == steamid) then
				key = k
				banni.bannedppl[k] = nil
			end
		end

		if(key == -1) then return "player is not banned" end

		banni.net({
			steamid = steamid,
			reason = reason,
			who = whosteamid,
			banned = false
		})

		local ply = player.GetBySteamID(steamid)

		if(ply ~= false) then
			ply.banni = false
			ply:SetRunSpeed(400)
			ply:SetJumpPower(200)
			ply:SetSuperJumpMultiplier(1.5)

			hook.Run("PlayerLoadout", ply)
		end
	end
end
local CATEGORY_NAME = "Utility"
--ulx.oldban = ulx.oldban or ulx.ban
function ulx.banni( calling_ply, target_ply, minutes, reason )
    if minutes == 0 then minutes = 60*60*24*30*12*3 end
    if not reason then reason = "Admin ma zawsze racje" end
    banni.ban(IsValid(calling_ply) and calling_ply:SteamID() or "Console",target_ply:SteamID(),minutes*60,reason)
end
local ban = ulx.command( CATEGORY_NAME, "ulx banni", ulx.banni, "!banni", false, false, true )
ban:addParam{ type=ULib.cmds.PlayerArg }
ban:addParam{ type=ULib.cmds.NumArg, hint="minutes, 0 for perma", ULib.cmds.optional, ULib.cmds.allowTimeString, min=0 }
ban:addParam{ type=ULib.cmds.StringArg, hint="reason", ULib.cmds.optional, ULib.cmds.takeRestOfLine, completes=ulx.common_kick_reasons }
ban:defaultAccess( ULib.ACCESS_ADMIN )
ban:help( "Bans target funs way." )

--ulx.oldunban = ulx.oldunban or ulx.unban

function ulx.banniunban( calling_ply, target_ply)
	--print(target_ply)
	banni.unban(IsValid(calling_ply) and calling_ply:SteamID() or "Console",target_ply:SteamID(),"unban")
end

local banniub = ulx.command( CATEGORY_NAME, "ulx unbanni", ulx.banniunban, "!unbanni", false, false, true )
banniub:addParam{ type=ULib.cmds.PlayerArg }
banniub:defaultAccess( ULib.ACCESS_ADMIN )
banniub:help( "UnBans target." )

function ulx.bannid( calling_ply, target_ply, minutes, reason )
    if minutes == 0 then minutes = 60*60*24*30*12*3 end
    if not reason then reason = "Admin ma zawsze racje" end
    banni.ban(IsValid(calling_ply) and calling_ply:SteamID() or "Console",target_ply,minutes*60,reason)
end
local ban = ulx.command( CATEGORY_NAME, "ulx bannid", ulx.bannid, "!bannid", false, false, true )
ban:addParam{ type=ULib.cmds.StringArg }
ban:addParam{ type=ULib.cmds.NumArg, hint="minutes, 0 for perma", ULib.cmds.optional, ULib.cmds.allowTimeString, min=0 }
ban:addParam{ type=ULib.cmds.StringArg, hint="reason", ULib.cmds.optional, ULib.cmds.takeRestOfLine, completes=ulx.common_kick_reasons }
ban:defaultAccess( ULib.ACCESS_ADMIN )
ban:help( "Bans target funs way." )

--ulx.oldunban = ulx.oldunban or ulx.unban

function ulx.bannidunban( calling_ply, target_ply)
	--print(target_ply)
	banni.unban(IsValid(calling_ply) and calling_ply:SteamID() or "Console",target_ply,"unban")
end

local banniub = ulx.command( CATEGORY_NAME, "ulx unbannid", ulx.bannidunban, "!unbannid", false, false, true )
banniub:addParam{ type=ULib.cmds.StringArg }
banniub:defaultAccess( ULib.ACCESS_ADMIN )
banniub:help( "UnBans target." )