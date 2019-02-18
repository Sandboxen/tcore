hook.Add("PlayerSay","commandhelpswep",function(ply,txt)
if txt == "!pomoc" then
ply:SendLua([[
HelpSwep.gui()
]])
return ""
elseif txt == "!pacignore" then
ply:SendLua([[
PacIgnoreList()
]])
return ""
elseif txt == "!cebulacoin" then
ply:SendLua([[
OpenVipGui()
]])
return ""
elseif txt == "!vip" then
ply:SendLua([[
chat.AddText(Color(255,0,0),"[INFO]",Color(255,255,255,255)," Aby kupic vipa na tydzien musisz posiadac 1 milion cebulacoin i wpisac !kupvip")
]])
return ""
elseif txt == "!kupvip" then
  if ply:GetMoney() >= 1000000 then
    ply:AddMoney(-1000000)
  ply:SetPData("vipexpire",os.time() + (60 * 60 * 24 * 7))
  ply:SetPData("groupbeforevip",ply:GetUserGroup())
  ulx.adduser( ply, ply, "vip" )
  else
  ply:SendLua([[chat.AddText(Color(255,0,0),"[INFO]",Color(255,255,255,255)," Nie masz tyle.")]])
  end
  return ""
elseif txt == "!pvp" then
  ply:ConCommand("cl_godmode 0")
  ply:SendLua([[chat.AddText(Color(255,0,0),"[INFO]",Color(255,255,255,255)," Włączono tryb pvp.")]])
  return ""
elseif txt == "!build" then
 ply:ConCommand("cl_godmode 1")
 ply:SendLua([[chat.AddText(Color(255,0,0),"[INFO]",Color(255,255,255,255)," Włączono tryb build.")]])
 return ""
end
end
)