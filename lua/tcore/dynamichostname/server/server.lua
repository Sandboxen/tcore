local hostnames = {
  "nie wiem co tu wpisac",
  }
  
  util.AddNetworkString("HostnameChangerSync")
  local activehostname = ""
  local k = 1
  local lastmsg = ""
  timer.Create("HostnameChanger",5,0,function()
    local wojenna = GetGlobalBool("wojenna")
    local ischatmess = false
    if hostnames[k] == "chatmess" then
      hostnames[k] = lastmsg
      ischatmess = true
    end
    game.ConsoleCommand("hostname [PL] Sandboxen 2.0 - "..(wojenna and "Stan Wojenny" or hostnames[k]).."\n")
    activehostname = "[PL] Sandboxen 2.0 - "..(wojenna and "Stan Wojenny" or hostnames[k])
    net.Start("HostnameChangerSync")
    net.WriteString(activehostname)
    net.Broadcast()
    if ischatmess then
      hostnames[k] = "chatmess"
    end
    if k + 1 > #hostnames then
        k = 1
    else
        k = k + 1
    end
  end)

  hook.Add("PlayerSay","GetLastMessageForDynamic",function(ply,txt)
    if not string.StartWith(txt,"!") then
      lastmsg = string.sub(txt,0,32)
      --print(lastmsg)
    end
  end)
