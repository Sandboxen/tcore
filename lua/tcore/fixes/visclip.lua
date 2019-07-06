if CLIENT then
    hook.Add("Think","VisClipRepair",function()
    net.Start("clipping_request_all_clips") net.SendToServer()
    end)
    
    concommand.Add("viscliprepair", function()
        net.Start("clipping_request_all_clips") net.SendToServer()
    end)
end