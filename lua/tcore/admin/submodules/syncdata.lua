if SERVER then
    util.AddNetworkString("TCore.AdminMod.SyncData")
    function TCore.AdminMod.SyncData(ply)
        net.Start("TCore.AdminMod.SyncData")
            local commands = TCore.AdminMod.Commands
            local tosend = {}
            tosend.commands = {}
            for i,v in pairs(commands) do
                table.insert(tosend.commands, {i,args=v.args,desc=v.desc})
            end
        net.Send(ply)
    end
else
    net.Receive("TCore.AdminMod.SyncData", function()
        local data = net.ReadTable()
        TCore.AdminMod.Commands = data.commands
    end)
end