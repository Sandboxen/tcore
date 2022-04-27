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
local spawnProtect = {}

local plymeta = FindMetaTable("Player")
function plymeta:SetBuildMode(bool)
    self:SetNWBool("buildmode",bool)
end
function plymeta:GetBuildMode()
    if GetGlobalBool("wojenna",false) then
        return false 
    else
        return self:GetNWBool("buildmode",false)
    end
end
hook.Add("OnPhysgunPickup","PropDupa",function(ply,ent) 
    if ent:GetClass() == "prop_physics" then
        ent.lastPicker = ply
    end
end)
hook.Add("EntityTakeDamage","BuildModeDamage",function(ent,dmg)
    local isbanni = ent.banni or false --XD
    if dmg:GetDamageCustom() == 21372137 and not string.StartWith(dmg:GetInflictor():GetClass(),"m9k_") then return end
    local attacker = dmg:GetAttacker()
    --print(ent,attacker)
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
                dmginfo:SetDamageCustom(21372137)
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
    if ent:GetClass() == "gmod_sent_vehicle_fphysics_base" then
        if attacker:IsPlayer() and attacker:GetBuildMode() then
            dmg:ScaleDamage(0)
        end
        if attacker:IsPlayer() and not attacker:GetBuildMode() and ent:CPPIGetOwner():GetBuildMode() then
            dmg:ScaleDamage(0)
        end
    end
    spawnProtect[ent] = spawnProtect[ent] or 0
    if IsValid(ent) and ent:IsPlayer() and (ent:GetBuildMode() or spawnProtect[ent] > CurTime()) then
        dmg:ScaleDamage(0)
        
    end
    if(IsValid(ent) and ent:IsPlayer() and IsValid(attacker) and attacker:IsPlayer()) then
        ent.damageFrom=ent.damageFrom or {}
        ent.damageFrom[attacker] = ent.damageFrom[attacker] or 0
        ent.damageFrom[attacker] = ent.damageFrom[attacker] + dmg:GetDamage()
    end
end)
local positions = {}
hook.Add("PlayerDeath","RepawnPos",function(ply, _, attacker)
    if(ply.damageFrom) then
        for i,v in pairs(ply.damageFrom) do
            if i:IsPlayer() and i != ply then
                if(v>0)then
                    i:AddMoney(math.Clamp(v,0,100)*4)
                end
            end
        end
    end
    ply.damageFrom = {}
    positions[ply]=ply:GetPos()
end)
hook.Add("PlayerSpawn","respawnpos",function(ply)
    if positions[ply] and ply:GetBuildMode() and not GetGlobalBool("wojenna",false) then
        ply:SetPos(positions[ply])
        positions[ply]=nil
    end
    if not ply:GetBuildMode() then
        spawnProtect[ply] = CurTime() + 5
    end
end)
hook.Add("PlayerNoClip","DisNoclip",function(ply,state)
    if (not ply:GetBuildMode()) and state == true then
        return false
    end
end)