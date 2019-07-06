local PCTasks = {}
_G.PCTasks = PCTasks
PCTasks.Store = {}

local PCTasksFinish = "PC_TASK_FINISH"
local PCTasksSend   = "PC_TASK_SEND"

PCTasks.Exists = function(name)
    if PCTasks.Store[name] then
        return true
    else
        return false
    end
end

PCTasks.IsCompleted = function(ply,name)
    if not IsValid(ply) then return false end
    return ply:GetNWBool("PCTask_"..name,false)
end

PCTasks.GetCompleted = function(ply)
    local results = {}
    if not IsValid(ply) then return results end
    for k,v in pairs(PCTasks.Store) do
        if ply:GetNWBool("PCTask_"..k) then
            results[k] = v
        end
    end
    return results
end

if SERVER then

    util.AddNetworkString(PCTasksSend)
    util.AddNetworkString(PCTasksFinish)
    
    net.Receive("PCTasksRequestTasks",function(_,ply)
    net.Start("PCTasksRequestTasks")
    net.WriteTable(PCTasks.Store)
    net.Send(ply)
    end)
    PCTasks.Send = function(ply)
        net.Start(PCTasksSend)
        net.WriteTable(PCTasks.Store)
        net.Send(ply)
        for name,_ in pairs(PCTasks.Store) do
            ply:SetNWBool("PCTask_"..name,ply:GetPData("PCTask_"..name,false))
        end
    end

    PCTasks.UpdateClients = function()
        for k,v in pairs(player.GetAll()) do
            if v.PCTasks_Init_Passed then
                PCTasks.Send(v)
            end
        end
    end

    PCTasks.Add = function(name,desc,xp)
        if PCTasks.Exists(name) then return end
        local desc = desc or name
        local xp = xp or 1000
        PCTasks.Store[name] = {}
        PCTasks.Store[name].desc = desc
        PCTasks.Store[name].XP = xp
        PCTasks.UpdateClients() --realtime task additions
    end

    PCTasks.Complete = function(ply,name)
        if IsValid(ply) and PCTasks.Exists(name) and not PCTasks.IsCompleted(ply,name) then
            ply:SetPData("PCTask_"..name,true)
            ply:SetNWBool("PCTask_"..name,true)
            net.Start(PCTasksFinish)
            net.WriteEntity(ply)
            net.WriteString(name)
            net.Broadcast()
            hook.Run("OnPCTaskCompleted",ply,name)
            if jlevel then
                jlevel.GiveXP(ply,PCTasks.Store[name].XP)
            end
        end
    end

    hook.Add("PlayerInitialSpawn","pctasks",function(ply)
        PCTasks.Send(ply)
        ply.PCTasks_Init_Passed = true
    end)
    hook.Add("PlayerSpawn","pctasks",function(ply)
    PCTasks.UpdateClients()        
    end)

end


if CLIENT then

    net.Receive(PCTasksSend,function()
        local tbl = net.ReadTable()
        PCTasks.Store = tbl
    end)

    net.Receive(PCTasksFinish,function()
        local ply = net.ReadEntity()
        local name = net.ReadString()
        hook.Run("OnPCTaskCompleted",ply,name)
    end)

    
end
