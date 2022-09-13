local activehostname = "[PL] Sandboxen"
net.Receive("HostnameChangerSync",function()
  activehostname = net.ReadString()
end)
function GetHostName()
  return activehostname
end