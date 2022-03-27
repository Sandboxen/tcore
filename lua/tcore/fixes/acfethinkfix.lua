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
    --[[lua/autorun/acf_extras.lua:309: attempt to call field 'oldThink' (a nil value)
  1. oldThink - requested:228
   2. unknown - lua/autorun/acf_extras.lua:309
]]
    concommand.Add("acfefix",function()
        for i,v in ipairs(ents.GetAll()) do
        if v.acfe_detected then
            if not v.oldThink then
                v.oldThink = function() end
            end
        end
    end
    end)
else
    hook.Add("ClientLuaError","AcfEFix",function(msg,stack,traceback,ply)
        if(msg == "lua/autorun/acf_extras.lua:309: attempt to call field 'oldThink' (a nil value)") then
            ply:ConCommand("acfefix")
        end
    end)
end

local tbl1 = physenv.GetPerformanceSettings() tbl1.MaxAngularVelocity = 30000 physenv.SetPerformanceSettings(tbl1)
local tbl2 = physenv.GetPerformanceSettings() tbl2.MaxVelocity = 20000 physenv.SetPerformanceSettings(tbl2)