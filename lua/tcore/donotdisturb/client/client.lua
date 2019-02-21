concommand.Add("dnd_whitelist",function()
    net.Start("GetWhitelist")
    net.SendToServer()
end)

local dnd = CreateConVar("dnd_enable","0",FCVAR_USERINFO )

--[[cvars.AddChangeCallback("dnd_enable",function()
    net.Start("DoNotDisturb")
    net.WriteBool(dnd:GetBool())
    net.SendToServer()
end)]]

net.Receive("GetWhitelist",function()
    local list = net.ReadTable()
    local menu = vgui.Create("DFrame")
    menu:SetTitle("Whitelist (Dbl click to remove)")
    menu:SetSize(200,300)
    menu:Center()
    menu:MakePopup()
    local dlist = vgui.Create("DListView",menu)
    dlist:AddColumn("Nick")
    dlist:AddColumn("SteamID64")
    dlist:Dock(FILL)
    for i,v in pairs(list) do
    dlist:AddLine(v[1],v[2])
    end

    dlist.DoDoubleClick = function(_,linen)
        local line = dlist:GetLine(linen)
        local a = line:GetColumnText(1)
        local b = line:GetColumnText(2)
        net.Start("WHRemovePerson")
        net.WriteString(a)
        net.WriteString(b)
        net.SendToServer()
        dlist:RemoveLine(linen)
    end

    local dbut = vgui.Create("DButton",menu)
    dbut:SetText("Add Someone")
    dbut.DoClick = function()
        local s = DermaMenu(menu)
        for i,v in ipairs(player.GetAll()) do
            if v != LocalPlayer() then
            s:AddOption(v:Name(),function()
                dlist:AddLine(v:Name(),v:SteamID64())
                net.Start("WHAddPerson")
                net.WriteEntity(v)
                net.SendToServer()
            end)
        end
        end
        s:Open()
    end
    dbut:Dock(BOTTOM)
end)