if SERVER then
util.AddNetworkString("ChatAddText")
chat = chat or {}
function chat.AddText(ply,...)
if not IsValid(ply) then return end
net.Start("ChatAddText")
net.WriteTable({...})
net.Send(ply)
end
else
net.Receive("ChatAddText",function()
local data = net.ReadTable()
chat.AddText(unpack(data))
end)
end