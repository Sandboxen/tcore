util.AddNetworkString("TagNetworker")
util.AddNetworkString("titleNetworker")
util.AddNetworkString("titlecolNetworker")
util.AddNetworkString("fake_nameNetworker")

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

net.Receive("titleNetworker",function(l,ply)
local tag = net.ReadString()
if tag:Trim() == "" then
ply:SetNWString("title","")
ply:SetPData("title","")
else
tag = string.sub(tag,1,64)
ply:SetNWString("title",tag)
ply:SetPData("title",tag)
end
end)

net.Receive("titlecolNetworker",function(l,ply)
local tag = net.ReadVector()
ply:SetNWVector("titlecol",tag)
ply:SetPData("titlecol",tag)
end)

net.Receive("fake_nameNetworker",function(l,ply)
local tag = net.ReadString()
if tag == "" then
ply:SetNWString("fake_name","")
ply:SetPData("fake_name","")
else
tag = string.sub(tag,1,16)
ply:SetNWString("fake_name",tag)
ply:SetPData("fake_name",tag)
end
end)

hook.Add("PlayerInitialSpawn",function(ply)
ply:SetNWString("Tag",ply:GetPData("Tag",""))
ply:SetNWString("fake_name",ply:GetPData("fake_name",""))
ply:SetNWString("title",ply:GetPData("title",""))
ply:SetNWVector("titlecol",ply:GetPData("titlecol",Vector(80,80,80)))
end)

