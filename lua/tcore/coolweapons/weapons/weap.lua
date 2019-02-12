local SWEP = {}
SWEP.Base = "weapon_base"
SWEP.PrintBase = "Bazinga"
SWEP.AdminOnly = true
SWEP.ViewModelFOV = 54
SWEP.ViewModel = "models/weapons/cstrike/c_shot_xm1014.mdl"
SWEP.WorldModel = "models/weapons/w_shot_xm1014.mdl"
SWEP.Holdtype = "pistol"
SWEP.Slot = 1
SWEP.SlotPos = 0
SWEP.UseHands = true
SWEP.PrintName = "Ur mom ghey"
SWEP.Spawnable = 1
SWEP.Primary = {}
SWEP.Primary.ClipSize = 5
SWEP.Primary.Automnatic = true
SWEP.Secondary = {}
SWEP.Secondary.ClipSize = 50
SWEP.Secondary.DefaultClip = 10
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

local Delay = 0.1

function SWEP:PrimaryAttack()

    if ( !self:CanPrimaryAttack() ) then return end

    self:EmitSound("weapons/capper_shoot.wav")

    -- Shoot 1 bullet, 150 damage, 0.01 aimcone
    self:ShootBullet( 10, 10,0.05 )

    -- Remove 1 bullet from our clip
    self:TakePrimaryAmmo( 1 )

    -- Punch the player's view
    --self.Owner:ViewPunch( Angle( -1, 0, 0 ) )

    self:SetNextPrimaryFire( CurTime() + Delay )

end

return SWEP