hook.Add("PlayerSpawnedSENT","RemoveMCSigns",function(_,ent)
if ent:GetClass() == "minecraft_sign" or ent:GetClass() == "minecraft_wall_sign" then
timer.Simple(0.5,function()
ent:SetText("PRZESTAN RESPIC\nTE TABLICZKI KURWA")
timer.Simple(10,function()
ent:Remove()
end)
end)
end
end)