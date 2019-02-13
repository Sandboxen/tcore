local activehostname = "[PL] Polski Sandbox"
net.Receive("HostnameChangerSync",function()
  activehostname = net.ReadString()
end)
function GetHostName()
  return activehostname
end