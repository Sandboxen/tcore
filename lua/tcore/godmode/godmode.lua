--from https://github.com/Re-Dream/misc/blob/master/lua/autorun/personal_godmode.lua
local tag = "personal_godmode"

if SERVER then
	local modes = {
		[0] = function(ply, attacker, allowFriends, noFallDmg) -- mortal
			if attacker:IsPlayer() and attacker:IsFriend(ply) then
				return allowFriends
			end
			return true
		end,
		[1] = function(ply, attacker, allowFriends, noFallDmg) -- godmode
			if attacker:IsPlayer() and attacker:IsFriend(ply) and allowFriends then
				return true
			end
			return false
		end,
		[2] = function(ply, attacker, allowFriends, noFallDmg) -- world only
			if attacker:IsPlayer() and attacker:IsFriend(ply) then
				return allowFriends
			end
			return not attacker:IsPlayer()
		end,
		[3] = function(ply, attacker, allowFriends, noFallDmg) -- protect from gods
			if attacker:IsPlayer() then
				if attacker:IsFriend(ply) then
					return allowFriends
				end
				local attackerGod = attacker:GetInfoNum("cl_godmode", -1) == 1
				return not attackerGod
			end
			return true
		end
	}
	hook.Add("GetFallDamage", tag, function(ply, speed)
		local noFallDmg = ply:GetInfoNum("cl_godmode_nofalldmg", 1) == 1
		if noFallDmg then return 0 end
	end)
	hook.Add("PlayerShouldTakeDamage", tag, function(ply, attacker)
		local god = ply:GetInfoNum("cl_godmode", -1)
		local allowFriends = ply:GetInfoNum("cl_godmode_allowfriends", 1) == 1
		local noFallDmg = ply:GetInfoNum("cl_godmode_nofalldmg", 1) == 1
		if attacker ~= NULL then
			local callback = modes[god]
			if callback then
				return callback(ply, attacker, allowFriends, noFallDmg)
			end
		end
	end)
elseif CLIENT then
	local cl_godmode = CreateClientConVar("cl_godmode", "1", true, true)
	local cl_godmode_allowfriends = CreateClientConVar("cl_godmode_allowfriends", "1", true, true)
	local cl_godmode_nofalldmg = CreateClientConVar("cl_godmode_nofalldmg", "1", true, true)

	language.Add(tag .. "_0", "Mortal")
	language.Add(tag .. "_1", "Godmode")
	language.Add(tag .. "_2", "World only")
	language.Add(tag .. "_3", "Protect from gods")
	hook.Add("PopulateToolMenu", tag, function()
		spawnmenu.AddToolMenuOption("Utilities",
			"User",
			tag,
			"God Mode", "", "",
			function(pnl)
				pnl:AddControl("Header", {
					Description = "Filter damage. What should be allowed to hurt you?"
				})

				pnl:AddControl("ListBox", {
					Options = {
						["#" .. tag .. "_0"] = { cl_godmode = 0 },
						["#" .. tag .. "_1"] = { cl_godmode = 1 },
						["#" .. tag .. "_2"] = { cl_godmode = 2 },
						["#" .. tag .. "_3"] = { cl_godmode = 3 },
					},
					Label = "Damage mode"
				})
				pnl:ControlHelp("\"World only\" will only protect from player damage.\n\"Protect from gods\" will disallow damage from god mode people while still allowing damage from vulnerable people.")

				pnl:AddControl("CheckBox", {
					Label = "Take damage from friends (overrides all modes)",
					Command = "cl_godmode_allowfriends",
				})

				pnl:AddControl("CheckBox", {
					Label = "Negate fall damage (when you would take any)",
					Command = "cl_godmode_nofalldmg",
				})
			end
		)
	end)

	local w = Color(194, 210, 225)
	local g = Color(127, 255, 127)
	hook.Add("OnPlayerChat", tag, function(ply, text)
		if ply ~= LocalPlayer() then return end

		local args = text:Split(" ")
		local cmd = args[1]
		table.remove(args, 1)
		local cmdPrefix = mingeban and mingeban.utils.CmdPrefix or "^[%$%.!/]"
		if cmd:match(cmdPrefix .. "god") then
			local mode = tonumber(args[1])
			mode = mode and math.Clamp(mode, 0, 3) or nil
			if mode then
				RunConsoleCommand("cl_godmode", mode)

				local modeStr = language.GetPhrase(tag .. "_" .. mode)
				surface.PlaySound("common/warning.wav")
				notification.AddLegacy('Godmode set to "' .. modeStr .. '".', NOTIFY_HINT, 5)
			else
				local availableModes = {}
				for i = 0, 3 do
					availableModes[#availableModes + 1] = "\t" .. i .. ": " .. language.GetPhrase(tag .. "_" .. i)
				end
				chat.AddText(w, "God modes available:\n", g, table.concat(availableModes, "\n"), w, "\nMore options in the ", g, "Spawn Menu", w, " > ", g, "Utilities", w, " > ", g, "God Mode", w, " menu!")
			end
		end
	end)
end

hook.Add("OnPlayerHitGround", tag, function(ply, speed)
	local noFallDmg = ply:GetInfoNum("cl_godmode_nofalldmg", 1) == 1
	if noFallDmg then return true end
end)