util.AddNetworkString("on_afk")
util.AddNetworkString("cl_on_afk")

net.Receive("on_afk", function(_, ply)
    local time = net.ReadFloat()
    local bool = (time > 0)

    hook.Run("OnPlayerAFK", ply, bool, ply:GetAFKTime())

    net.Start("cl_on_afk")
    net.WriteEntity(ply)
    net.WriteBool(bool)
    net.WriteFloat(ply:GetAFKTime())
    net.Broadcast()

    ply:SetNWFloat("afk", time)
end)