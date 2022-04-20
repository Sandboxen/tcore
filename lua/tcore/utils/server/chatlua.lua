local easylua = trequire("easylua")
local luadev = trequire("luadev")
util.AddNetworkString("TCoreLuaReturn")
local function run(func, script, ply, name) --from https://github.com/PAC3-Server/notagain/blob/master/lua/notagain/aowl/commands/lua.lua
	local valid, err = luadev.ValidScript(script, name)
	if not valid then return false, err end
	return func(script, luadev.GetPlayerIdentifier(ply, "cmd:" .. name), {sender = ply})
end
local mathenv = math

local function calc(exp)
    local data = CompileString("return "..exp,":script_error",false)
    if type(data) == "function" then
        setfenv(data,mathenv)
        local result = data()
        if result then
            return true,result
        else
            return false,exp .. " = nil"
        end
    else
        return false,data
    end
end

hook.Add("PlayerSay","TCoreLua",function(ply,txt)
    if string.StartWith(txt,"!lsv") and (ply:IsSuperAdmin() or ply:IsTomek()) then
        local script = string.sub(txt,6)
        timer.Simple(0.1,function()
        easylua.Start(ply)
        run(luadev.RunOnServer, script, ply, "lsv")
        easylua.End()
        end)
        --return ""
    end
    if string.StartWith(txt,"!math") then
        local script = string.sub(txt,7)
        local ok,wynik = calc(script)
        
        net.Start("TCoreLuaReturn")
        net.WriteString(script)
        net.WriteString(script)
        net.WriteBool(ok)
        net.WriteTable({wynik})
        net.Broadcast()
    end
end)

hook.Add("LuaDevProcess","TCoreRunLua",function(stage,script,chunkname,extra,func,args,ok,returnvals)
    if stage == luadev.STAGE_POST then
        local vals = {}
        for i,v in ipairs(returnvals) do table.insert(vals,tostring(v)) end
        net.Start("TCoreLuaReturn")
        net.WriteString(chunkname)
        net.WriteString(script)
        net.WriteBool(ok)
        net.WriteTable(vals)
        net.Broadcast()
    end
end)