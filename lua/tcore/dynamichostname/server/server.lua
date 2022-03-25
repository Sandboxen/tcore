local hostnames = {
  "ACF/E2/SProps/PAC3",
  "chatmess",
  "Fajna zabawa",
  "chatmess",
  "Frajer Pompka Jestes",
  "chatmess",
  "D00psko",
  "chatmess",
  "Admin chity",
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
    game.ConsoleCommand("hostname [PL] Polski Sandbox - "..(wojenna and "Stan Wojenny" or hostnames[k]).."\n")
    activehostname = "[PL] Polski Sandbox - "..(wojenna and "Stan Wojenny" or hostnames[k])
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
      print(lastmsg)
    end
  end)
