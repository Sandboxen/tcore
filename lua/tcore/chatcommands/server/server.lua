hook.Add("PlayerSay","commandhelpswep",function(ply,txt)
if txt == "!pomoc" then
ply:SendLua([[
HelpSwep.gui()
]])
return ""
elseif txt=="!jebacdisa" then
ply:ChatPrint("http://tomekb530.me/jd.html")
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

local poopoo = CreateConVar("poopoo", "0")
hook.Add("PlayerSay","AGowno",function(ply,txt)
local ok
  if poopoo:GetBool() then
    local data = string.Split(txt," ")
    if #data < 10 and #data > 2 then
      local _,k = table.Random(data)
      data[k] = "gówno"
      ok = table.concat(data," ")
    elseif #data > 10 then
    for m=1,math.floor(#data/5) do
      local _,k = table.Random(data)
      data[k] = "gówno"
      ok = table.concat(data," ")
    end
    end
    return ok or txt
  end
end)
