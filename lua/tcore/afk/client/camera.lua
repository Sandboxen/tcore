local tag = "AFKmera"
local afkmera_enable = CreateConVar("cl_afkmera_enable", "1", { FCVAR_ARCHIVE }, "Should AFKmera be active or not?")
local afkmera_anim_enable = CreateConVar("cl_afkmera_anim_enable", "1", { FCVAR_ARCHIVE }, "Should we change the playermodel's animation while AFK or not?")
local afkmera_transition_speed = CreateConVar("cl_afkmera_transition_speed", "0.66", { FCVAR_ARCHIVE }, "The time it takes to go from player eyes to AFKmera and vice versa.")
local afkmera_rotation_speed = CreateConVar("cl_afkmera_rotation_speed", "0.5", { FCVAR_ARCHIVE }, "How fast the AFKmera should rotate around the player. (negative = other way)")
local afkmera_fov = CreateConVar("cl_afkmera_fov", "60", { FCVAR_ARCHIVE }, "Field of view of the AFKmera.")
local afkmera_dist = CreateConVar("cl_afkmera_dist", "10", { FCVAR_ARCHIVE }, "Distance between the AFKmera and the player.")
local afkmera_height = CreateConVar("cl_afkmera_height", "0.25", { FCVAR_ARCHIVE }, "Height of the AFKmera.")
local afkmera_pitch = CreateConVar("cl_afkmera_pitch", "-15", { FCVAR_ARCHIVE }, "Angle pitch of the AFKmera.")
local afkmera_simulate = CreateConVar("cl_afkmera_simulate", "0", { FCVAR_ARCHIVE }, "Force AFKmera to be active (to test and set other ConVars as you like)")

local camDist = 0
local camHeight = 0
local fieldOfView = 0
local act = ""
local newAct = false
local newActDelay = 0
local lastWeapon = false
local spawned = 0

local idleSequences = {
	["^idle_all"]      = { act = "pose_standing_0", random = true },
	["^idle_fist"]     = { act = "pose_standing_0", random = true },
	["^idle_grenade"]  = { act = "idle_all_0",      random = true },
	["^idle_slam"]     = { act = "idle_all_0",      random = true },
	["^idle_pistol"]   = { act = "idle_all_0",      random = true },
	["^idle_revolver"] = { act = "idle_all_0",      random = true },
	["^idle_ar2"]      = { act = "idle_passive" },
	["^idle_smg1"]     = { act = "idle_passive" },
	["^idle_physgun"]  = { act = "idle_passive" },
	["^idle_rpg"]      = { act = "idle_passive" },
	["^idle_shotgun"]  = { act = "idle_passive" },
	["^idle_crossbow"] = { act = "idle_passive" },
}
local function GetNewSequence(ply)
	local wep = ply:GetActiveWeapon()
	if wep == NULL then return end
	if not lastWeapon or not wep:GetClass():match(lastWeapon) then
		act = ""
		newAct = false
		newActDelay = RealTime() + (0.1 * FrameTime())
		lastWeapon = ply:GetActiveWeapon():GetClass()
	end
	if not newAct and newActDelay < RealTime() then
		for from, to in pairs(idleSequences) do
			if ply:GetSequenceName(ply:GetSequence()):match(from) then
				act = to.act .. (to.random and math.random(1, 2) or "")
				newAct = true
			end
		end
	end
end

local noAFKEntities = {
	gmod_playx = true,
	gmod_playx_repeater = true,
	gmod_playx_proximity = true,
}
hook.Add("CalcView", tag, function(ply, basePos, baseAng, baseFov, nearZ, farZ)
	if not afkmera_enable:GetBool() or spawned > CurTime() then return end

	local IsAFK = false
	local simulate = afkmera_simulate:GetBool() or false
	if ply.IsAFK and ply:IsAFK() or simulate then IsAFK = true end

	local transitionSpeed = afkmera_transition_speed:GetFloat() or 1
	local fov = afkmera_fov:GetFloat() or 70
	camDist 	= math.Clamp(Lerp(FrameTime() * (10 * transitionSpeed), camDist, IsAFK and 1 or 0), 0, 1)
	if camDist <= 0.005 then return end

	local dead = false
	if ply:Health() <= 0 or ply:Crouching() or ply:InVehicle() then dead = true end
	camHeight   = Lerp(FrameTime() * (10 * transitionSpeed), camHeight, dead and 1 or 0)

	fieldOfView = Lerp(FrameTime() * (10 * transitionSpeed), fieldOfView, IsAFK and fov or baseFov)

	local trace = ply:GetEyeTrace()
	local badEntity = false
	if trace.Entity ~= nil and trace.Entity ~= NULL and noAFKEntities[trace.Entity:GetClass()] then badEntity = true end

	if not badEntity then
		GetNewSequence(ply)

		local rotationSpeed = afkmera_rotation_speed:GetFloat() or 1
		local dist = afkmera_dist:GetFloat() or 0
		local height = math.Clamp(afkmera_height:GetFloat(), 0.25, 2) or 0.66
		local pitch = afkmera_pitch:GetFloat() or 0

		local _, maxs = ply:GetModelBounds()
		local plyPos = ply:Health() <= 0 and ply:GetRagdollEntity():GetPos() or ply:GetPos()
		local pos = plyPos + Vector(0, 0, maxs.z * height - (maxs.z / 3 * camHeight))
		dist = Vector(maxs.z * 2 + dist, 0, 0)
		local lookAway = Angle(pitch, RealTime() * (15 * rotationSpeed) % 360, 0)
		dist:Rotate(lookAway)
		local aroundMe = pos + dist
		local lookAtMe = (pos - aroundMe):Angle()
		trace = {}
		trace.start = pos
		trace.endpos = aroundMe
		trace.filter = ply
		trace.mask = MASK_SOLID_BRUSHONLY
		trace = util.TraceLine(trace)
		aroundMe = trace.HitPos

		local pos = LerpVector(camDist, basePos, aroundMe)
		local ang = LerpAngle(camDist, baseAng, lookAtMe)

		local view = {}
		view.origin = pos
		view.angles = ang
		view.fov = fieldOfView
		view.znear = nearZ
		view.zfar = farZ
		view.drawviewer	= camDist >= 0.1

		return view
	else
		newAct = false
		lastWeapon = false
	end
end)

hook.Add("CalcMainActivity", tag, function(ply)
	if not afkmera_enable:GetBool() or not afkmera_anim_enable:GetBool() then return end

	local IsAFK = false
	local simulate = afkmera_simulate:GetBool() or false
	if ply:EntIndex() == LocalPlayer():EntIndex() and (ply.IsAFK and ply:IsAFK() or simulate) and ply:GetVelocity():Length() <= 10 then IsAFK = true end
	if IsAFK and act ~= "" then
		local seq = ply:LookupSequence(act)
		return seq, seq
	end
end)