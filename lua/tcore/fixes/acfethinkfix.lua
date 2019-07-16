if CLIENT then
--[[hook.Add("Think","ACFEFix",function()
    for i,v in ipairs(ents.GetAll()) do
        if v.acfe_detected then
            if not v.oldThink then
                v.oldThink = function() end
            end
        end
    end
    end)]]--FUCKING MISTAKE
    concommand.Add("acfefix",function()
        for i,v in ipairs(ents.GetAll()) do
        if v.acfe_detected then
            if not v.oldThink then
                v.oldThink = function() end
            end
        end
    end
    end)
end