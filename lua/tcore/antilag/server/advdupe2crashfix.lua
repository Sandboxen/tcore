hook.Add("CanTool", "AdvDupe2AntiCrash",function(ply,trace,tool)
    if IsValid(ply) and tool == "advdupe2" and ply.AdvDupe2 and ply.AdvDupe2.Entities then
        for i,v in pairs(ply.AdvDupe2.Entities) do
            if v.ModelScale and v.ModelScale > 10 then
            ply.AdvDupe2.Entities[i].ModelScale = 10
            for i,v in ipairs(player.GetHumans()) do
                chat.AddText(v,Color(128,0,255),"[SERVER]",Color(255,0,0)," ",ply:Nick(),Color(230,230,230)," probowal zrespic duzego propa!")
            end
            --return false
            end
        end
    end
end)