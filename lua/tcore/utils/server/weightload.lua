--[[hook.Add("Think","UpdateWeightVar",function()
    for i,v in ipairs(ents.GetAll()) do
        if IsValid(v) then
            local physobj = v:GetPhysicsObject()
            if IsValid(physobj) then
                v:SetNWFloat("WeightSync",physobj:GetMass())
            end
        end 
    end
end)]]--LAGGY AF
--hook.Remove("Think","UpdateWeightVar")