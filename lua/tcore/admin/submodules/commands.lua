if SERVER then
    TCore.AdminMod.Commands = TCore.AdminMod.Commands or {}
    function TCore.AdminMod.RegisterCommand(name, desc, args, access, callback)
        TCore.AdminMod.Commands[name] = {
            desc = desc,
            args = args,
            access = access,
            callback = callback
        }
    end

    function TCore.AdminMod.GetAccess(ply)
        return 100
    end

    local function findPlys(txt)
        local plys = {}
        for k,v in pairs(player.GetAll()) do
            local nickfinder = string.find(string.lower(v:Nick()),string.lower(txt))
            if nickfinder and nickfinder >= 0 then
                table.insert(plys,v)
            elseif string.lower(v:SteamID()) == string.lower(txt) or string.lower(v:SteamID64()) == string.lower(txt) then
                table.insert(plys,v)
            end
        end
        return plys
    end

    local argTypes = {
        ["player"] = function(txt)
            local plys = findPlys(txt)
            if #plys == 1 then
                return plys[1]
            else
                return nil
            end
        end,
        ["players"] = function(txt)
            if txt == "*" then
                return player.GetAll()
            end
            local plys = findPlys(txt)
            if #plys > 0 then
                return plys
            else
                return nil
            end
        end,
        ["string"] = function(txt)
            return txt
        end,
        ["number"] = function(txt)
            return tonumber(txt)
        end
    }

    

    function TCore.AdminMod.ArgParser(str)
        local args = {}
        local exploded = string.Explode(" ",str)
        --first pass, remove spaces
        for i,v in ipairs(exploded) do
            if(string.Trim(v) == "") then
                continue
            end
            table.insert(args,v)
        end
        --second pass, connect strings with ""
        for i,v in ipairs(args) do
            if string.StartWith(v,[["]]) then
                if string.EndsWith(v,[["]]) then
                    args[i] = string.sub(v,2,-2)
                    continue
                end
                local i1 = i
                local i2 = i
                table.remove(args,i1)
                for i2,v2 in ipairs(args) do
                    if string.EndsWith(v2,[["]]) then
                        local str = string.sub(v,2) .. " " .. string.sub(v2,1,-2)
                        table.remove(args,i2)
                        table.insert(args,i1,str)
                        break
                    end
                end
            end
        end

        return args
    end

    function TCore.AdminMod.ArgCompute(types,args)
        local newArgs = {}
        local count = 1
        for i,v in ipairs(types) do
            if v[2] then
                if args[count] then
                    local arg = argTypes[v[1]](args[count])
                    if arg then
                        table.insert(newArgs,arg)
                        count = count + 1
                    else
                        return "Invalid Argument ".. count ..": " .. v[1],nil
                    end
                else
                    return "Missing Argument ".. count ..": " .. v[1],nil
                end
            else
                if args[count] then
                    local arg = argTypes[v[1]](args[count])
                    if arg then
                        table.insert(newArgs,arg)
                        count = count + 1
                    end
                end
            end
        end
        return nil,newArgs
    end


    hook.Add("PlayerSay","TCore.AdminMod.CommandListener",function(ply,txt)
        if string.sub(txt,1,1) == "!" then
            local args = string.Explode(" ",txt)
            local cmd = string.sub(args[1],2)
            table.remove(args,1)
            local argsStr = table.concat(args," ")
            local command = TCore.AdminMod.Commands[cmd]
            local parsed = TCore.AdminMod.ArgParser(argsStr)
            local err,argsData = TCore.AdminMod.ArgCompute(command.args,parsed)
            if(argsData) then
                command.callback(ply,argsData)
                return ""
            else
                timer.Simple(0.1,function()
                    ply:ChatPrint(err)
                end)
            end
        end
    end)
end