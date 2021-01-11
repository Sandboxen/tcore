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
elseif txt == "!vip" then
ply:SendLua([[
OpenVipGui()
]])
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
