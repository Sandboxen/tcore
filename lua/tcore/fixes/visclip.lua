if CLIENT then
local lastcmd = 0
   --[[ hook.Add("Think","VisClipRepair",function()
    net.Start("clipping_request_all_clips") net.SendToServer()
    end)]]--FUCKING MISTAKE OK
    concommand.Add("viscliprepair", function()
    if lastcmd < CurTime() then
        net.Start("clipping_request_all_clips") net.SendToServer()
        lastcmd = CurTime()+10
    end
    end)
else
hook.Add("ClientLuaError","VisClip",function(msg,stack,traceback,ply)
if(msg and msg == "lua/autorun/client/clipping.lua:118: attempt to index a nil value")then
ply:ConCommand("viscliprepair")
end
end)
end