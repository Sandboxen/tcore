if SERVER then
  local prondsays = {}
      local spammers = {}
timer.Create("LoadTasks",5,1,function()
TCore.msg("Loaded Tasks")
PCTasks.Add("Pierwszy Raz","Dołącz po raz pierwszy na serwer!")
PCTasks.Add("Szybszy Niż Światło","Newton nie miał racji.")
PCTasks.Add("Morderca","Bądź Mordercą.")
PCTasks.Add("Pierwsze Słowa","Mama? Tata?")
PCTasks.Add("ADMIN LAGIII!","Przeżyj Laga Serwera.")
PCTasks.Add("KAMPER !!","Zostań Zabity.")
PCTasks.Add("Pewnie Z Neta","Załóż PACa.")
PCTasks.Add("Elektryk","'wikinta prondem'")
PCTasks.Add("Fagmin Pomocy","Napisz coś do Adminów.")
PCTasks.Add("Error","Dostań Errora.")
PCTasks.Add("No Scam","100% working")
PCTasks.Add("ić stont","Zobacz jak ktoś obrywa.")
PCTasks.Add("Trust me I am engineer","Użyj narzędzia")
PCTasks.Add("Jedyny Słuszny","Advanced Duplicator 2")
PCTasks.Add("Niemieckie łącze","Ping over 800")
PCTasks.Add("Oświetleniowiec","Dobre światła ziomek.")
PCTasks.Add("W Grupie raźniej","Dołącz do grupy.")
PCTasks.Add("Słofnig","Naudż siem mufić.")
PCTasks.Add("Prestiż","Kup vipa.")
PCTasks.Add("Szybkie palce :lenny:","Wygraj w przepisywaniu.")
PCTasks.Add("Quick maths","Policz minigre.")
PCTasks.Add("Prezencik","Dostań Prezent")
PCTasks.Add("Wędkarz","Złów coś.")
PCTasks.Add("Deskord","Połącz konto na discordzie.")
end)
hook.Add("PlayerFinishedLoading","Achievement",function(ply)
PCTasks.Complete(ply,"Pierwszy Raz")
end)
hook.Add("PrePACConfigApply","pc_task_pac_wore_first_time",function(ply)
       PCTasks.Complete(ply,"Pewnie Z Neta")
   end)
   hook.Add("PlayerSay","pc_task_first_words",function(ply)
         PCTasks.Complete(ply,"Pierwsze Słowa")
     end)
hook.Add("Move","pc_task_faster_than_light",function(ply)
    if ply:GetVelocity():Length() >= 2000 then
        PCTasks.Complete(ply,"Szybszy Niż Światło")
    end
    hook.Add("PlayerDeath","pc_task_otherworld",function(ply,_,ent)
      PCTasks.Complete(ply,"KAMPER !!")
      if ent:IsPlayer() and ent ~= ply then
          PCTasks.Complete(ent,"Morderca")
      end
  end)
  hook.Add("PlayerSay","elektryk",function(ply,txt)
    if not prondsays[ply] then prondsays[ply] = 0 end
        if txt == "wikinta prondem" then
          prondsays[ply] = prondsays[ply] +1
        end
        if prondsays[ply] == 5 then
          PCTasks.Complete(ply,"Elektryk")
        end
    end)
    hook.Add("CanTool","achievementTool",function(ply,_,str)
      PCTasks.Complete(ply,"Trust me I am engineer")
      if str == "advdupe2" then
      PCTasks.Complete(ply, "Jedyny Słuszny")
      end
    end)

    hook.Add("PlayerSay","freevip",function(ply,txt)
      if string.sub(txt,1,8) == "!freevip" then
        PCTasks.Complete(ply,"No Scam")
        return ""
      end
    end)
    hook.Add("PlayerSay","słofnig",function(ply,txt)
      if not PCTasks.IsCompleted(ply,"Słofnig") then
      if string.find(txt,"chui") or string.find(txt,"łuć") or string.find(txt,"warszama") or string.find(txt,"hui") or string.find(txt,"dembil") or string.find(txt,"muj") or string.find(txt,"włonczyć") then
        PCTasks.Complete(ply,"Słofnig")
        return ""
      end
      end
    end)
    hook.Add("ULibCommandCalled","fagminachieve",function(ply,txt)
      if txt == "ulx asay" then
        PCTasks.Complete(ply,"Fagmin Pomocy")
      end
    end)
    hook.Add("ULibCommandCalled","zlyprzyklad",function(ply,txt)
      if txt == "ulx ban" or txt == "ulx kick" or txt=="ulx mute" or txt=="ulx gag" then
        if not IsValid(ply) or ply:GetUserGroup() == "wlasciciel" or ply:GetUserGroup() == "superadmin" or ply:GetUserGroup() == "admin" or  ply:GetUserGroup() == "moderator" then
          for i,v in ipairs(player.GetAll()) do
            PCTasks.Complete(v,"ić stont")
          end
        end
      end
    end)
    hook.Add("ClientLuaError","erroachieve",function( ply)
      PCTasks.Complete(ply,"Error")
    end)
    hook.Add("Tick","pingachive",function()
      for i,v in ipairs(player.GetAll()) do
        if v:Ping() > 800 then
            PCTasks.Complete(v,"Niemieckie łącze")
        end
        if not PCTasks.IsCompleted(v,"Prestiż") then
          if v:GetUserGroup() == "vip" then
            PCTasks.Complete(v,"Prestiż")
          end
        end
      end
    end)

local complete = function() end

if PCTasks and PCTasks.Add and PCTasks.Complete then
	complete = function(ply)
		PCTasks.Complete(ply,"Oświetleniowiec")
	end
end

hook.Add("PlayerSwitchFlashlight", "flashlight-spam", function(ply, enabled)

	if ply:CanUseFlashlight() and enabled then
		spammers[tostring(ply:UserID())] = spammers[tostring(ply:UserID())] or {}
		local key = spammers[tostring(ply:UserID())]

		key.times = key.times and key.times + 1 or 1
		key.when = key.when or CurTime()
		if key.times > 4 then
			--ply.haltgodmode = true
			--ply:Ignite(3,0)

			local can = ply:CanUseFlashlight()
			ply:AllowFlashlight(false)
			ply:EmitSound('buttons/button10.wav')

			timer.Simple(4, function()
				if IsValid(ply) then
					--ply.haltgodmode = nil
					ply:AllowFlashlight(can)
					spammers[tostring(ply:UserID())] = nil
					complete(ply)
				end
			end)
		end

		if key.when+1 < CurTime() then
			spammers[tostring(ply:UserID())] = nil
		end
	end
end)
end)
end
if CLIENT then
  local prettytext = trequire("pretty_text")

  function draw.OutlinedBox( x, y, w, h, thickness, clr )
  	surface.SetDrawColor( clr )
  	for i=0, thickness - 1 do
  		surface.DrawOutlinedRect( x + i, y + i, w - i * 2, h - i * 2 )
  	end
  end

  function draw.AchievementBox(x,y,w,h,text,lower)
  	if prettytext then
  	surface.SetDrawColor(Color(33, 33, 33))
  	surface.DrawRect(x,y,w,h)
  	draw.OutlinedBox(x,y,w,h,3,Color(80,80,80))
  	surface.SetDrawColor(Color(0,0,0))
  	surface.DrawLine(x-1,y+1,x-1,y+h-2)
  	surface.DrawLine(x+1,y-1,x+w-2,y-1)
  	surface.DrawLine(x+1,y+h,x+w-2,y+h)
  	surface.DrawLine(x+w,y+1,x+w,y+h-2)
  	prettytext.DrawText({
  	font = "ChatFont",
  	text = text,
  	x = x+10,
  	y = y+6,
  	size = 25,
  	blur_size = 1,
  	foreground_color = Color(255,255,0,255),
  	background_color = Color(255,255,0,255),
  	blur_overdraw = 2,
  	})
  	prettytext.DrawText({
  	font = "ChatFont",
  	text = lower,
  	x = x+10,
  	y = y+34,
  	size = 25,
  	blur_size = 1,
  	foreground_color=Color(255,255,255,255),
  	background_color = Color(255,255,0,255),
  	blur_overdraw = 2,
  	})
  end
  end
  function sendAchievement(text,lower)
  local w,h = 350,70
  local y = -h-10
  local hiding = false
  timer.Create("HideAchivement",7,1,function()
  hiding = true
  end)
  hook.Add("HUDPaint","kek",function()
  	if hiding then y=y-100*FrameTime() else y=y+100*FrameTime() end
  	y = math.Clamp(y,-h-11,0)
  	draw.AchievementBox(ScrW()/2-w/2,y,w,h,text,lower)
  	if y == -h-11 then
  	hook.Remove("HUDPaint","kek")
  end
  end)
  end
  hook.Add("OnPCTaskCompleted","pctasks",function(ply,task)
      chat.AddText(ply,Color(200,200,200)," zdobył osiągnięcie [",Color(244, 167, 66),task,Color(200,200,200),"]")
    if ply == LocalPlayer() then
      --sendAchievement(task,PCTasks.Store[task].desc)
    end
  end)
  surface.CreateFont("AchievementName",{
    font="Arial",
    size=35,
  })

  surface.CreateFont("AchievementDesc",{
    font="Arial",
    size=15,
  })

  concommand.Add("achievement_list",function()
    local menu = vgui.Create("DFrame")
    menu:SetTitle("Achievements")
    menu:SetSize(500,400)
    menu:Center()
    menu.Paint = function(_,w,h)
      surface.SetDrawColor(Color(20,20,20,200))
      surface.DrawRect(0,0,w,h)
    end
    menu:MakePopup()
    local dscroll = vgui.Create("DScrollPanel",menu)
    dscroll:Dock(FILL)
    for i,v in pairs(PCTasks.Store) do
      local p = vgui.Create("DPanel",dscroll)
      p:SetHeight(60)
      p.Paint = function(_,w,h)
        surface.SetDrawColor(PCTasks.IsCompleted(LocalPlayer(),i) and Color(0,150,0,200) or Color(150,0,0,200))
        surface.DrawRect(0,0,w,h)
      end
      p:Dock(TOP)
      local name = vgui.Create("DLabel",p)
      name:SetText(i)
      surface.SetFont("AchievementName")
      local w,h = surface.GetTextSize(i)
      name:SetHeight(h)
      name:SetContentAlignment(5)
      name:Dock(TOP)
      name:SetTextColor(Color(255,255,255,255))
      name:SetFont("AchievementName")
      local desc = vgui.Create("DLabel",p)
      desc:SetText(v["desc"])
      desc:SetFont("AchievementDesc")
      desc:SetContentAlignment(5)
      desc:SetTextColor(Color(255,255,255,255))
      desc:Dock(BOTTOM)
    end
  end)
end
