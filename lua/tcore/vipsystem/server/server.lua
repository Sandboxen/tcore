local weeknumer = 76480
local monthnumer = 79480

util.AddNetworkString("tb530vipbuy")
util.AddNetworkString("tb530vipguiopen")
util.AddNetworkString("InfoBuyed")
--local day = 86400


local function checkVip(smscode,numer,succ,fail)
http.Fetch("https://microsms.pl/api/check.php?userid=2190&number=" .. numer .. "&code=" .. smscode .. "&serviceid=5210", function(bd)
    local code = string.sub(bd,1,1)
    if code == "1" then
        succ()
    elseif code == "0" or code == "E" then
        fail()
    end
end)
end

hook.Add("Think","VipChecker",function()
  for i,ply in ipairs(player.GetAll()) do
    local data = ply:GetPData("vipexpire",-1)
    local group = ply:GetPData("groupbeforevip","user")
    data = tonumber(data)
    if data ~= -1  and data < os.time() then
        ulx.adduser(ply,ply,group)
        ply:SetPData("vipexpire","-1")
        return
    end
  end
end)

local function giveVipFor(ply,howlong)
  ply:SetPData("vipexpire",os.time() + howlong)
  ply:SetPData("groupbeforevip",ply:GetUserGroup())
  ulx.adduser( ply, ply, "vip" )
end

net.Receive("tb530vipbuy",function(_,ply)
local code = net.ReadString()
local numer = net.ReadString()
numer = tonumber(numer)
if numer == weeknumer then
checkVip(code,numer,function()
        net.Start("InfoBuyed")
        net.WriteEntity(ply)
        net.WriteString(tostring(1000000))
        net.Broadcast()
    ply:AddMoney(1000000)
end,
function()
    ply:SendLua([[notification.AddLegacy("Błędny Kod!",NOTIFY_ERROR,5)]])
end)
elseif numer == monthnumer then
checkVip(code,numer,function()
        net.Start("InfoBuyed")
        net.WriteEntity(ply)
        net.WriteString(tostring(4000000))
        net.Broadcast()
    ply:AddMoney(4000000)
end,
function()
    ply:SendLua([[notification.AddLegacy("Błędny Kod!",NOTIFY_ERROR,5)]])
end)
end
end)