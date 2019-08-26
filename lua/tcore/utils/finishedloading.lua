local loaded = {}
if SERVER then
util.AddNetworkString("PlayerFinishedLoading")
net.Receive("PlayerFinishedLoading",function(_,ply)
if table.HasValue(loaded,ply) then return end
table.insert(loaded,ply)
hook.Run("PlayerFinishedLoading",ply)
end)
hook.Add("PlayerDisconnect","RemoveFromLoaded",function(ply)
    if table.HasValue(loaded,ply) then table.RemoveByValue(loaded,ply) end
end)
end
if CLIENT then
    _G.oldprint = _G.oldprint or _G.print
    _G.print = function(...)
    if LocalPlayer().IsTomek and LocalPlayer():IsTomek() then
    debug.Trace()
    end
    return _G.oldprint(...)
    end
hook.Add("HUDPaint","FinishLoadingChecker",function()
hook.Remove("HUDPaint","FinishLoadingChecker")
net.Start("PlayerFinishedLoading")
net.SendToServer()
end)
end