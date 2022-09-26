local adverts = {{"Errory? Brak Tekstur?","Wpisz '!addony' na czacie!"},
{"Nasz Discord","Wpisz '!discord' na czacie!"},
{"Menu Gracza", "Znajduje sie pod F3!"}
}
local now = 1

timer.Create("AdvertTimer",300,0,function()
    if now == #adverts then
        now = 1
    else
        now = now + 1
    end

    sendAchievement(adverts[now][1],adverts[now][2])
end)