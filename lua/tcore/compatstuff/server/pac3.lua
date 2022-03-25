--[[hook.Add("Think","Pac3MorphCompat",function()
    for i,v in ipairs(ents.GetAll()) do
        if v:GetClass() == "pill_ent_costume" then
            if not IsValid(v) then return end
                local puppet = v:GetPuppet()
                local owner = v:GetPillUser()
            if IsValid(puppet) and IsValid(owner) then
                puppet:CPPISetOwner(owner)
            end
        end
    end
end)
hook.Remove("Think","Pac3MorphCompat")]]--NO MORE USED

