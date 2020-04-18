properties.Add("ClipboardStuff",{
    MenuLabel   =   "Copy To Clipboard",
    Order = 2003,
    MenuIcon    =   "icon16/script.png",
    Filter = function(self, ent, ply)
                --if not IsValid(ent) then return false end
                return true
            end,

    MenuOpen = function( self, option, ent, tr )
        local submenu = option:AddSubMenu()
        if (IsValid(ent)) then
            submenu:AddOption("Model", function()
                if(IsValid(ent)) then SetClipboardText(ent:GetModel()) end
            end)
            submenu:AddOption("Class", function()
                if(IsValid(ent)) then SetClipboardText(ent:GetClass()) end
            end)
            submenu:AddOption("Position", function()
                local pos = ent:GetPos()
                if(IsValid(ent)) then SetClipboardText(pos.x..","..pos.y..","..pos.z) end
            end)
            submenu:AddOption("Angle", function()
                local ang = ent:GetAngles()
                if(IsValid(ent)) then SetClipboardText(ang.p..","..ang.y..","..ang.r) end
            end)
            if(ent:GetMaterial()=="")then
                local materials = submenu:AddSubMenu("Material")
                for i,v in ipairs(ent:GetMaterials()) do
                    materials:AddOption(v, function()
                        if(IsValid(ent)) then SetClipboardText(v) end
                    end)
                end
            else
                submenu:AddOption("Material", function()
                    if(IsValid(ent)) then SetClipboardText(ent:GetMaterial()) end
                end)
            end
            submenu:AddOption("Color", function()
                local color = ent:GetColor()
                if(IsValid(ent)) then SetClipboardText(color.r..","..color.g..","..color.b..","..color.a) end
            end)
            submenu:AddOption("Entity ID", function()
                if(IsValid(ent)) then SetClipboardText(ent:EntIndex()) end
            end)

            if(ent:IsPlayer())then
                submenu:AddSpacer()
                submenu:AddOption("Nick", function()
                    if(IsValid(ent)) then SetClipboardText(ent:Nick()) end
                end)
                submenu:AddOption("SteamID", function()
                    if(IsValid(ent)) then SetClipboardText(ent:SteamID()) end
                end)
                submenu:AddOption("SteamID64", function()
                    if(IsValid(ent)) then SetClipboardText(ent:SteamID()) end
                end)
            end
        else
            submenu:AddOption("Position", function()
                local pos = tr.HitPos
                SetClipboardText(pos.x..","..pos.y..","..pos.z)
            end)
        end
    end
}
)
properties.List["drive"] = nil