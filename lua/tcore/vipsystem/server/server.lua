util.AddNetworkString("tb530vipbuy")
util.AddNetworkString("tb530vipcheck")
util.AddNetworkString("tb530vipguiopen")
util.AddNetworkString("tb530vipguiopenurl")
util.AddNetworkString("InfoBuyed")
--local day = 86400

local function checkVip(smscode,succ,fail)
    http.Fetch("https://loading.tomekb530.me/vip/check/"..smscode,function(bd)
        local data = util.JSONToTable(bd)
        if data.payed then
            succ(data.amountInt)
        else
            fail()
        end
    end,fail)
end

timer.Create("vipcheck",60,0,function()
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

net.Receive("tb530vipcheck",function(_,ply)
    local id = net.ReadString()

    checkVip(id,function(amount)
        if amount == 1200 then
            giveVipFor(ply,60*60*24*30)
        elseif amount == 100 then
            giveVipFor(ply,60*60*24*7)
        end
    end,function()
    
    end)
end)

net.Receive("tb530vipbuy",function(_,ply)
    local amount = net.ReadString()
    http.Fetch("https://loading.tomekb530.me/vip/buy/"..amount,function(bd)
        local data = util.JSONToTable(bd)
        local url = data.url
        local id = data.id
        net.Start("tb530vipguiopenurl")
        net.WriteString(url)
        net.WriteString(id)
        net.Send(ply)
    end)
end)