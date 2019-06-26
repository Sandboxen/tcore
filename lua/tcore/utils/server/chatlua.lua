local easylua = trequire("easylua")
local luadev = trequire("luadev")
util.AddNetworkString("TCoreLuaReturn")
local function run(func, script, ply, name) --from https://github.com/PAC3-Server/notagain/blob/master/lua/notagain/aowl/commands/lua.lua
	local valid, err = luadev.ValidScript(script, name)
	if not valid then return false, err end
	return func(script, luadev.GetPlayerIdentifier(ply, "cmd:" .. name), {sender = ply})
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