hook.Add("PlayerInitialSpawn","LoadPlayerBuildmodeStatus",function(ply)
    if ply:IsValid() then
        local data = ply:GetPData("buildmode",true)
        ply:SetNWBool("buildmode",data)
    end
end)
hook.Add("PlayerDisconnected","SavePlayerBuildmodeStatus",function(ply)
    if ply:IsValid() then
        ply:SetPData("buildmode",ply:GetNWBool("buildmode"))
    end
end)

local plymeta = FindMetaTable("Player")
function plymeta:SetBuildMode(bool)
    self:SetNWBool("buildmode",bool)
end
function plymeta:GetBuildMode()
    return self:GetNWBool("buildmode",false)
end
hook.Add("OnPhysgunPickup","PropDupa",function(ply,ent) 
    if ent:GetClass() == "prop_physics" then
        ent.lastPicker = ply
    end
end)
hook.Add("EntityTakeDamage","BuildModeDamage",function(ent,dmg)
    local isbanni = ent.banni or false --XD
    if dmg:GetDamageCustom() == 2137 then return end
    local attacker = dmg:GetAttacker()
    if ent:IsPlayer() and attacker:GetClass() == "prop_physics" then
        attacker = attacker.lastPicker or attacker:CPPIGetOwner()
    end
    if IsValid(ent) and IsValid(attacker) then
        if ent:IsPlayer() and attacker:IsPlayer() then
            if ent:GetBuildMode() and not attacker:GetBuildMode() then
                local dmginfo = DamageInfo()
                dmginfo:SetDamage(dmg:GetDamage())
                dmginfo:SetDamageType(DMG_DISSOLVE)
                dmginfo:SetDamageCustom(2137)
                dmginfo:SetInflictor(ent)
                dmginfo:SetAttacker(ent)
                attacker:TakeDamageInfo(dmginfo)
                dmg:ScaleDamage(0)
            end
            if attacker:GetBuildMode() and (ent:GetBuildMode() and not isbanni) then
                dmg:ScaleDamage(0)
            end
        end
    end
end)
local positions = {}
hook.Add("PlayerDeath","RepawnPos",function(ply)
    positions[ply]=ply:GetPos()
end)
hook.Add("PlayerSpawn","respawnpos",function(ply)
    if positions[ply] and ply:GetBuildMode() then
        ply:SetPos(positions[ply])
        positions[ply]=nil
    end
end)