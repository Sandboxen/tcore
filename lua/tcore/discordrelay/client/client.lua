net.Receive("DiscordMsg",function()
local ply = net.ReadString()
local msg = net.ReadString()
local data = ply .. ": " .. msg
chat.AddText(Color(114,137,218,255), "[Discord] ",Color(255,255,255,255),data)
end)