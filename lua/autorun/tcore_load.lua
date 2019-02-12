if !luaerror and SERVER then
    require("luaerror")
end
if (!TCore) then
include("tcore.lua")
end

hook.Add("PreGamemodeLoaded","TCore_Init",function()
TCore.init()
hook.Remove("PreGamemodeLoaded","TCore_Init")
end)
