local hostnames = {
  "ACF/E2/SProps/PAC3",
  "chatmess",
  "Zapraszamy!",
  "chatmess",
  "Frajer Pompka Jestes",
  "chatmess",
  "D00psko",
  "chatmess",
  "Admin chity",
  "chatmess",
  }
  
  util.AddNetworkString("HostnameChangerSync")
  local activehostname = ""
  local k = 1
  local lastmsg = ""
  timer.Create("HostnameChanger",5,0,function()
    local wojenna = GetGlobalBool("wojenna")
    local ischatmess = false
    if hostnames[k] == "chatmess" then
      if lastmsg == "" then
        hostnames[k] = hostnames[k+1]
      else
        hostnames[k] = lastmsg
      end
      ischatmess = true
    end
    game.ConsoleCommand("hostname [PL] Sandboxen - "..(wojenna and "Stan Wojenny" or hostnames[k]).."\n")
    activehostname = "[PL] Sandboxen - "..(wojenna and "Stan Wojenny" or hostnames[k])
    net.Start("HostnameChangerSync")
    net.WriteString(activehostname)
    net.Broadcast()
    if ischatmess then
      hostnames[k] = "chatmess"
      if lastmsg == "" then
        k = k + 1
      end
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
