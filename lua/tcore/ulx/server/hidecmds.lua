hook.Add("PlayerInitialSpawn","ULXWorkAround",function()
    for i,v in pairs(ULib.sayCmds) do
        ULib.sayCmds[i].hide = true
    end
end)
    for i,v in pairs(ULib.sayCmds) do
        ULib.sayCmds[i].hide = true
    end