util.AddNetworkString("TagNetworker")
net.Receive("TagNetworker",function(l,ply)
local tag = net.ReadString()
if tag:Trim() == "" then
ply:SetNWString("Tag"," ")
ply:SetPData("Tag"," ")
else
tag = string.sub(tag,1,16)
ply:SetNWString("Tag",tag)
ply:SetPData("Tag",tag)
end
end)
util.AddNetworkString("NickNetworker")
net.Receive("NickNetworker",function(l,ply)
local tag = net.ReadString()
if tag == "" then
ply:SetNWString("fake_name",false)
ply:SetPData("fake_name",false)
else
tag = string.sub(tag,1,16)
ply:SetNWString("fake_name",tag)
ply:SetPData("fake_name",tag)
end
end)

hook.Add("PlayerInitialSpawn",function(ply)
ply:SetNWString("Tag",ply:GetPData("Tag"," "))
ply:SetNWString("fake_name",ply:GetPData("fake_name",false))
end)
