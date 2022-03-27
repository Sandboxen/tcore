if !luaerror and SERVER then
    local ok, why = pcall(require,"luaerror")
    if !ok then
        print(why)
    end
end
if (!TCore) then
include("tcore.lua")
end

hook.Add("PreGamemodeLoaded","TCore_Init",function()
TCore.init()
hook.Remove("PreGamemodeLoaded","TCore_Init")
end)