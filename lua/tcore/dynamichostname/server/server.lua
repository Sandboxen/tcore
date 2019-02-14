local hostnames = {
  --"guwno/guwno/guwno/TS/guwno/guwno/guwno/guwno/guwno",
  "Zapraszamy !",
  "Życzymy miłej gry!",
  "Build/PVP",
  "FASTDL",
  "HL2(EP)/CSS/CSGO/L4D2/PORTAL2",
  "WIRE/ACF/SF/SPROPS/M9K",
  "PAC3/OUTFITTER",
  "DUŻO ADDONÓW !",
  --":thinking:",
  "Najlepszy Sandbox w Polsce!",
  "Szybkie dołączanie!!",
  "Wielkie Poprawki!",
  --"Jesteśmy Najlepsi!",
  --"KONKURENCJA DLA PEWNEJ SIECI OMG",
  --"My myslimy nie to co reszta",
  --"Dla prawdziwych budowniczych",
  --"Istniejemy od 3 lat!",
  "Lepszy niz inne serwery",
  --"Fiku miku i skok z klifu",
  --"Dawaj spotkamy sie w realu",
  --"Śmieszki",
  --"Animated Emoji WOAH",
  --"WPIERDOLMY/DUZO/TAGOW/I/JESZCZE/TROCHE+TS3",
  --"KASYNO !!",
  "WIELKI UPDATE 21.37",
  --"PoProstuDzbanyXD"
  }
  util.AddNetworkString("HostnameChangerSync")
  local activehostname = ""
  local k = 1
  timer.Create("HostnameChanger",5,0,function()
    game.ConsoleCommand("hostname [PL] Polski Sandbox - "..hostnames[k].."\n")
    activehostname = "[PL] Polski Sandbox - "..hostnames[k]
    net.Start("HostnameChangerSync")
    net.WriteString(activehostname)
    net.Broadcast()
    if k + 1 > #hostnames then
        k = 1
    else
        k = k + 1
    end
  end)