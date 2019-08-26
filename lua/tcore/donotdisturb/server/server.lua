local ply = FindMetaTable("Player")
util.AddNetworkString("DoNotDisturb")
util.AddNetworkString("GetWhitelist")
util.AddNetworkString("WHAddPerson")
util.AddNetworkString("WHRemovePerson")

function ply:GetDNDWhitelist()
    local t = util.JSONToTable(self:GetPData("dnd_whitelist","[]"))
    return t
end
function ply:GetDNDAccess(who)
    if self:IsDND() == false then return true end
    local wh = self:GetDNDWhitelist()
    for i,v in pairs(wh) do
        if v[2] == who:SteamID64() then
            return true
        end
    end
    return false
end
net.Receive("WHAddPerson",function(_,who)
    local list = util.JSONToTable(who:GetPData("dnd_whitelist","[]"))
    local target = net.ReadEntity()
    list[target:Name()] = {target:Name(),target:SteamID64()}
    local s = util.TableToJSON(list)
    who:SetPData("dnd_whitelist",s)
end)

net.Receive("WHRemovePerson",function(_,who)
        local list = util.JSONToTable(who:GetPData("dnd_whitelist","[]"))
        --local name = net.ReadString()
        local sid = net.ReadString()
        for i,v in pairs(list) do
            if v[2] == sid then
                list[i] = nil
            end
        end
        local s = util.TableToJSON(list)
        who:SetPData("dnd_whitelist",s)
end)

net.Receive("GetWhitelist",function(_,who)
    local list = util.JSONToTable(who:GetPData("dnd_whitelist","[]"))
    net.Start("GetWhitelist")
    net.WriteTable(list)
    net.Send(who)
end)
function ply:IsDND()
    return self:GetInfoNum("dnd_enable", 0) == 1
end
net.Receive("DoNotDisturb",function(_,who)
    local toggle = net.ReadBool()
    who:SetPData("DoNotDisturb",toggle)
end)

ulx.oldgoto = ulx.oldgoto or ulx.goto
function ulx.goto(c,t)
    --print(c,t)
    if t:GetDNDAccess(c) or c:IsSuperAdmin() or c:IsAdmin() or c:GetUserGroup() == "operator" then
        return ulx.oldgoto(c,t)
    else
        c:SendLua([[chat.AddText(Color(255,0,0),"[SERVER] ",Color(255,255,255),"Gracz ma włączone DND!")]])
        return
    end
end
local goto = ulx.command( "Teleport", "ulx goto", ulx.goto, "!goto" )
goto:addParam{ type=ULib.cmds.PlayerArg, target="!^", ULib.cmds.ignoreCanTarget }
goto:defaultAccess( ULib.ACCESS_ADMIN )
goto:help( "Goto target." )