cebulacoin = cebulacoin or {}
local plyMeta = FindMetaTable("Player")
function plyMeta:GetMoney()
return tonumber(self:GetNWString("cebulacoin",0))
end
function plyMeta:getDarkRPVar(var)
    if var == "money" then
        return self:GetMoney()
    end
    return nil
end
local charset = {}
for i = 65,  90 do table.insert(charset, string.char(i)) end
for i = 97, 122 do table.insert(charset, string.char(i)) end
for i = 97, 122 do table.insert(charset, string.char(i)) end
local function stringrandom(length)
  math.randomseed(os.time())

  if length > 0 then
    return stringrandom(length - 1) .. charset[math.random(1, #charset)]
  else
    return ""
  end
end
DarkRP = DarkRP or {}
DarkRP.notify =  function() end
if SERVER then
--SHADY DARKRP COMPAT :trolltomek: im lazy to edit addons xD

function plyMeta:AddMoney(much)
local money = self:GetNWString("cebulacoin",0)
much = math.floor(much)
if much >= 0 then
self:SendLua([[chat.AddText(Color(128,0,255),"[SERVER]",Color(230,230,230)," Otrzymałeś ",Color(255,0,0),"]]..math.abs(much)..[[$")]])
else
self:SendLua([[chat.AddText(Color(128,0,255),"[SERVER]",Color(230,230,230)," Straciłeś ",Color(255,0,0),"]]..math.abs(much)..[[$")]])
end
self:SetNWString("cebulacoin",money+much)
self:SetPData("cebulacoin",self:GetMoney())
end
plyMeta.addMoney = plyMeta.AddMoney

function plyMeta:GiveMoneyTo(who,much)
much = math.floor(math.abs(much))
if much > 0 and IsValid(who) and self:GetMoney() >= much then
self:AddMoney(-much)
who:AddMoney(much)
chat.AddText(who,Color(128,0,255),"[SERVER]",Color(230,230,230)," Otrzymałeś ",Color(255,0,0),much,"$ ",Color(230,230,230),"od ",Color(255,0,0),self:Name(),Color(230,230,230),"!")
chat.AddText(self,Color(128,0,255),"[SERVER]",Color(230,230,230)," Dałeś ",Color(255,0,0),much,"$ ",Color(230,230,230),"dla ",Color(255,0,0),who:Name(),Color(230,230,230),"!")
end
end
local timeouts = {}
function plyMeta:SetMoney(much)
self:SetNWString("cebulacoin",math.floor(much))
end
    util.AddNetworkString("CebulaCoinEventSet")
    util.AddNetworkString("CebulaCoinDrop")
    util.AddNetworkString("CebulaCoinGive")
    net.Receive("CebulaCoinGive",function(_,ply)
    local much = tonumber(net.ReadString())
    much = math.floor(much)
    local who = net.ReadEntity()
    ply:GiveMoneyTo(who,much)
    end)
    net.Receive("CebulaCoinDrop",function(_,ply)
    timeouts[ply] = timeouts[ply] or 0
    if timeouts[ply] < CurTime() then
        local much = tonumber(net.ReadString())
        much = math.Clamp(much, 0, tonumber(ply:GetMoney()))
        if tonumber(ply:GetMoney()) >= tonumber(much) then
            local coin = ents.Create("coin")
            local hitpos = ply:GetEyeTrace().HitPos
            local spawnpos = ply:GetPos():Distance(hitpos) > 300 and ply:LocalToWorld(Vector(150,0,10)) or hitpos+Vector(0,0,10)
            coin:SetPos(spawnpos)
            coin:Spawn()
            coin:SetMoney(much)
            timer.Simple(0.1,function()
                coin:SetNWBool("work",true)
            end)
            coin:CPPISetOwner(ply)
            ply:AddMoney(-much)
            timeouts[ply] = CurTime() + 5
        end
    end
    end)
    hook.Add("PlayerInitialSpawn","LoadMoney",function(ply)
    ply:SetMoney(ply:GetPData("cebulacoin",1000))
    end)

    hook.Add("PlayerDisconnected","SaveMoney",function(ply)
    ply:SetPData("cebulacoin",ply:GetMoney())
    end)
    function cebulacoin.SetEvent(str)
        net.Start("CebulaCoinEventSet")
        net.WriteString(str)
        net.Broadcast()
    end
    function cebulacoin.TypingGame()
        local totype = stringrandom(10)
        local cash = math.floor(math.Rand(100,300))
        cebulacoin.SetEvent("Przepisz: "..totype.." aby dostać "..cash.."$")
        hook.Add("PlayerSay","CebulaType",function(ply,txt)
        --print(txt,totype)
            if txt == totype then
            timer.Simple(0.1,function()
                ply:AddMoney(cash)
                cebulacoin.SetEvent("Wygrał "..ply:Nick().."!")
                PCTasks.Complete(ply,"Szybkie palce :lenny:")
                timer.Destroy("CebulaCoinTypeNo")
                timer.Simple(5,function()
                cebulacoin.SetEvent("")
                end)
                end)
                hook.Remove("PlayerSay","CebulaType")
            end
        end)
        timer.Create( "CebulaCoinTypeNo",60,1,function()
        cebulacoin.SetEvent("Nikt nie przepisal na czas!")
        hook.Remove("PlayerSay","CebulaType")
        timer.Simple(5,function()
        cebulacoin.SetEvent("")
        end)
        end)
    end
    function cebulacoin.MathGame()
        local firstnum = math.floor(math.Rand(1,100))
        local secondnum = math.floor(math.Rand(1,100))
        local maths = math.floor(math.Rand(1,3))
        local cash = math.floor(math.Rand(100,300))
        local char = "+"
        if(maths == 2)then char = "-" end
        if(maths == 3)then char = "*" end
        local mathtodo = firstnum..char..secondnum
        local result = CompileString("return ("..mathtodo..")","CebulaMaths")
        totype = result()
        totype = tostring(totype)
        cebulacoin.SetEvent("Oblicz: "..mathtodo.." aby dostać "..cash.."$")
        hook.Add("PlayerSay","CebulaType",function(ply,txt)
        --print(txt,totype)
            if txt == totype then
            timer.Simple(0.1,function()
                ply:AddMoney(cash)
                cebulacoin.SetEvent("Wygrał "..ply:Nick().."!")
                PCTasks.Complete(ply,"Quick maths")
                timer.Destroy("CebulaCoinTypeNo")
                timer.Simple(5,function()
                cebulacoin.SetEvent("")
                end)
                end)
                hook.Remove("PlayerSay","CebulaType")
            end
        end)
        timer.Create( "CebulaCoinTypeNo",60,1,function()
        cebulacoin.SetEvent("Nikt nie obliczyl na czas!")
        hook.Remove("PlayerSay","CebulaType")
        timer.Simple(5,function()
        cebulacoin.SetEvent("")
        end)
        end)
    end
print("CebulaCoin Games Start")
function cebulacoin.RandomGaem()
local what = math.Rand(1,2)
if what > 1.5 then
cebulacoin.MathGame()
else
cebulacoin.TypingGame()
end
end

timer.Create("CebulaMinigameTimer", 60*10, 0, cebulacoin.RandomGaem)
cebulacoin.RandomGaem()
else
    net.Receive("CebulaCoinEventSet",function()
        local str = net.ReadString()
        cebulacoin.event = str
    end)
    concommand.Add("dropcoins",function(ply,cmd,args)
            local much = tonumber(args[1]) or 0
            much = math.floor(much)
            much = math.Clamp(much, 0, tonumber(ply:GetMoney()))
            net.Start("CebulaCoinDrop")
            net.WriteString(tostring(math.abs(much)))
            net.SendToServer()
        end)
    local function findply(data)
        for i,v in ipairs(player.GetAll()) do
            if v:Nick():lower() == data:lower() then
                return v
            end
        end
    end
    local cooldown =  0
    concommand.Add("givecoins",function(ply,cmd,args)
    local much = tonumber(args[2]) or 0
    local who = findply(args[1])
    if cooldown > CurTime() then
        chat.AddText(Color(128,0,255),"[SERVER]",Color(230,230,230)," Poczekaj!")
        return
    end
    if not who then 
    chat.AddText(Color(128,0,255),"[SERVER]",Color(230,230,230)," Nie znaleziono gracza o takim nicku!")
    return
    end
    much = math.floor(much)
    much = math.Clamp(much, 0, tonumber(ply:GetMoney()))
    net.Start("CebulaCoinGive")
    net.WriteString(tostring(math.abs(much)))
    net.WriteEntity(who)
    net.SendToServer()
    cooldown = CurTime()+3
    end,function(cmd)
        local tbl = {}
        for i,v in ipairs(player.GetAll()) do
        table.insert(tbl,cmd.." "..v:Nick())
        end
        return tbl
    end)
end
