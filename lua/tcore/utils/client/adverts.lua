local adverts = {{"Errory? Brak Tekstur?","Wpisz '!addony' na czacie!"},
{"Nasz Discord","Wpisz '!discord' na czacie!"}
}
local now = 1

timer.Create("AdvertTimer",600,0,function()
    if now == #adverts then
        now = 1
    else
        now = now + 1
    end

    sendAchievement(adverts[now][1],adverts[now][2])
end)