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
    if GetGlobalBool("wojenna",false) == false then
        local isbanni = ent.banni or false --XD
        if dmg:GetDamageCustom() == 2137 then return end
        local attacker = dmg:GetAttacker()
        if ent:IsPlayer() and (attacker:GetClass() == "prop_physics" or attacker:GetClass() == "starfall_prop") then
            attacker = attacker.lastPicker or attacker:CPPIGetOwner()
        end
        if ent:IsPlayer() and attacker:GetClass() == "gmod_sent_vehicle_fphysics_base" then
            if IsValid(attacker:GetDriverSeat():GetDriver()) then
                if not attacker:GetDriverSeat():GetDriver():GetBuildMode() then
                    if attacker:CPPIGetOwner() != attacker:GetDriverSeat():GetDriver() then
                        attacker = attacker:GetDriverSeat():GetDriver()
                    else
                        attacker:ApplyDamage(dmg:GetDamage(),DMG_BLAST)
                    end
                end
            else
                attacker = attacker.lastPicker or attacker:CPPIGetOwner()
            end
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
                end
                if attacker:GetBuildMode() and (ent:GetBuildMode() and not isbanni) then
                    dmg:ScaleDamage(0)
                end
                if not ent:GetBuildMode() and attacker:GetBuildMode() then
                    dmg:ScaleDamage(0)
                end
            end
        end
        if IsValid(ent) and ent:IsPlayer() and ent:GetBuildMode() then
            dmg:ScaleDamage(0)
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