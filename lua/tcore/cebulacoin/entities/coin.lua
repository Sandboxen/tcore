local ENT = {}
ENT.Base = "base_entity"
ENT.Type = "anim"
ENT.Spawnable = false
function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "Money" )
end
if SERVER then

function ENT:Initialize()

	self:SetModel( "models/props_pipes/pipe03_connector01.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
    self:SetMaterial("models/debug/debugwhite")
    self:SetColor(Color(229,255,0))
    self:SetAngles(Angle(-90,0,0))
    self:SetNWBool("work",false)
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end
function ENT:StartTouch(ply)
	if(IsValid(ply) and ply:IsPlayer() and self:GetNWBool("work",false))then
		ply:AddMoney(self:GetMoney())
		self:Remove()
	end
end
else

function ENT:Draw()
	self:DrawModel()
	cam.Start3D2D(self:LocalToWorld(Vector(2,0,0)),self:LocalToWorldAngles(Angle(0,90,90)),0.1)
	surface.SetTextColor(Color(255,255,255))
	surface.SetFont("Coolvetica outlined50")
	local tw,th = surface.GetTextSize(self:GetMoney().."$")
	surface.SetTextPos(-tw/2,-th/2)
	surface.DrawText(self:GetMoney().."$")
	cam.End3D2D()
end

end

return ENT