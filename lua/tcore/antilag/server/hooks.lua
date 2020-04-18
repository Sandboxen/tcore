local wasLag = false
hook.Add( "LagDetectorDetected", "MyLagDetectorDetected", function() 
wasLag = true
for i,v in ipairs(player.GetAll()) do
    PCTasks.Complete(v,"ADMIN LAGIII!")
end
BroadcastLua([[chat.AddText(Color(128,0,255),"[SERVER]",Color(230,230,230)," Wykryto Laga! Zamrażam Wszystkie Propy!")]])
for i,v in ipairs(ents.GetAll()) do
    local obj = v:GetPhysicsObject()
    local emptyvec = Vector()
    if IsValid(obj) then
    obj:EnableMotion(false)
    end
end
BroadcastLua([[chat.AddText(Color(128,0,255),"[SERVER]",Color(230,230,230)," Szukam winowajcy!")]])
local ppl = {}
local pplents = {}
for i,v in ipairs(ents.GetAll()) do
    if IsValid(v) and v.CPPIGetOwner and v:CPPIGetOwner() then
    local owner = v:CPPIGetOwner()
    --if not IsValid(v:GetParent()) then
    ppl[owner] = ppl[owner] or 0
    ppl[owner] = ppl[owner] + 1
    pplents[owner] = pplents[owner] or {}
    table.insert(pplents[owner],v)
    --end
    end
end
timer.Simple(0.3,function()
local winner
for i,v in pairs(ppl) do
    if not winner then winner = i
        if v > ppl[winner] then winner = i end
    end
end
timer.Simple(0.3,function()
BroadcastLua([[chat.AddText(Color(128,0,255),"[SERVER]",Color(230,230,230)," Najwięcej propów zrespił: <hsv=[tick()*2],1,1>]].. winner:Nick() .." ["..ppl[winner].."] "..[[")]])
--[[BroadcastLua([[chat.AddText(Color(128,0,255),"[SERVER]",Color(230,230,230)," Powiadomiono Administrację!")]]--[[)
local relay = TCore.discordrelay
local nick = winner:Nick()
local sid = winner:SteamID()
TCore.GetAvatar(sid,function(ret)
local embeds = {
    [1] = {
            description = "Sprawca",
            color = 255,
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
            author = {
                name = nick,
                url = "http://steamcommunity.com/profiles/" .. util.SteamIDTo64(sid),
                icon_url = ret 
            }
    },
    [2] = {
            description = "Liczba propów",
            color = 255,
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
            author = {
                name = ppl[winner],
                url = "http://steamcommunity.com/profiles/" .. util.SteamIDTo64(sid),
                icon_url = ret
            }
    }
}
local admins = "<@&257532593145118721><@&262158797424820224><@&270585312797917194><@&268084336870293508> "
relay:SendMessage({avatar_url="https://cdn.discordapp.com/avatars/431413205605023755/f06c3a070adf795b540b1499d009ea71.png?size=1024",username="Serwer",content="Był Lag!",
embeds=embeds
})
end)]]--Maybe not idk


end)
end)
end)
hook.Add( "LagDetectorQuiet", "MyLagDetectorQuiet", function() 
if wasLag then
BroadcastLua([[chat.AddText(Color(128,0,255),"[SERVER]",Color(230,230,230)," Lag się uspokoił!")]]) 
wasLag = false
end
end)
hook.Add( "LagDetectorMeltdown", "MyLagDetectorMeltdown", function() 
BroadcastLua([[chat.AddText("Jakiś potężny Lag! Cleanupuję mapę!")]])
game.ConsoleCommand("ulx cleanup")
end)