local ENT = {}
ENT.Base = "base_anim"
ENT.PrintName = "Gift"
ENT.Author = "Tomekb530"
ENT.Information = "Prezent"
ENT.Category = "Tomekb530"

ENT.Editable = false
ENT.Spawnable = true
ENT.AdminOnly = false
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

canRun = false

function ENT:SpawnFunction( ply, tr, ClassName )
if PCTasks then
	if PCTasks.IsCompleted(ply,"Prezencik") then
	if ( !tr.Hit ) then return end
	local ent = ents.Create( ClassName )
	ent:SetPos( tr.HitPos + tr.HitNormal)
	ent:Spawn()
	ent:Activate()

	return ent
end
end
end

if SERVER then
function ENT:Initialize()

	self:SetModel( "models/props_halloween/halloween_gift.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox

        local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:Use(a)
if a:GetPos():Distance(self:GetPos()) < 80 then
PCTasks.Complete(a,"Prezencik")
self:Remove()
end
end
end

return ENT