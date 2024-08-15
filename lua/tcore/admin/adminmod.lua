--[[TCore.AdminMod = TCore.AdminMod or {}
TCore.AdminMod.Config = TCore.AdminMod.Config or {}
TCore.AdminMod.Permissions = TCore.AdminMod.Permissions or {}


local basegroups = {
    "owner","superadmin","admin","operator","user"
}

local baseperms = {
    ["owner"] = {"*"},
    ["superadmin"] = {"*"},
    ["admin"] = {},
    ["operator"] = {},
    ["user"] = {},
}


include("submodules/commands.lua")
AddCSLuaFile("submodules/commands.lua")



include("submodules/syncdata.lua")
AddCSLuaFile("submodules/syncdata.lua")
if SERVER then
    util.AddNetworkString("TCore.AdminMod.Reload")
    local function loadConfig()
        local config = file.Read("tcore/adminmod/config.txt","DATA")
        if config then
            TCore.AdminMod.Config = util.JSONToTable(config)
        else
            TCore.AdminMod.Config = {
                ["defaultgroup"] = "user",
                ["groups"] = basegroups,
                ["permissions"] = baseperms,
            }
            file.Write("tcore/adminmod/config.txt",util.TableToJSON(TCore.AdminMod.Config))
        end
    end

    local function saveConfig()
        file.Write("tcore/adminmod/config.txt",util.TableToJSON(TCore.AdminMod.Config))
    end

    local function createSQLTables()
        if not sql.TableExists("tcore_adminmod_groups") then
            sql.Query("CREATE TABLE tcore_adminmod_groups (steamid TEXT, group TEXT)")
        end
        if not sql.TableExists("tcore_adminmod_permissions") then
            sql.Query("CREATE TABLE tcore_adminmod_permissions (steamid TEXT, permission TEXT)")
        end
    end

    hook.Add("TCoreFinishInit","TCore.AdminMod.Init",function()
        loadConfig()
        createSQLTables()
        TCore.AdminMod.Permissions = TCore.AdminMod.Config.permissions
        TCore.AdminMod.Commands = TCore.AdminMod.Config.commands
        loadModules()
    end)

    concommand.Add("tcore_adminmod_reload",function(ply)
        if ply:IsSuperAdmin() then
            loadConfig()
            createSQLTables()
            TCore.AdminMod.Permissions = TCore.AdminMod.Config.permissions
            TCore.AdminMod.Commands = TCore.AdminMod.Config.commands
            loadModules()
            net.Start("TCore.AdminMod.Reload")
            net.Broadcast()
        end
    end)

    hook.Add("ShutDown","TCore.AdminMod.Shutdown",function()
        saveConfig()
    end)

else
    net.Receive("TCore.AdminMod.Reload",function()
        loadModules()
    end)
end
]]--