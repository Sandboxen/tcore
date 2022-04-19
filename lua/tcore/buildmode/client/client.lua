local plymeta = FindMetaTable("Player")
function plymeta:SetBuildMode(bool)
    self:SetNWBool("buildmode",bool)
end
function plymeta:GetBuildMode()
    return self:GetNWBool("buildmode")
end