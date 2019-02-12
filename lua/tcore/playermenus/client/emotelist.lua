if CLIENT then

local function OpenEmoteGui()
local menu = vgui.Create("DFrame")
menu:SetSize(ScrW() / 6,ScrH() / 2)
menu:Center()
menu:MakePopup()
menu:SetTitle("EMOTE MENU")
menu.Paint = function(s,w,h)
surface.SetDrawColor(Color(20,20,20,200))
surface.DrawRect(0,0,w,h)
end

local base = vgui.Create("DScrollPanel",menu)
base:Dock(FILL)
local filter = vgui.Create("DTextEntry",menu)
filter:Dock(BOTTOM)
filter:SetPlaceholderText("Filtr")
filter:RequestFocus()
local loaded = false


local function loaddata(str)
  local tabele = {}
  if str then
    if string.StartWith(str,"gif") then
      str = string.sub(str,4)
      for i,v in pairs(chathud.Shortcuts) do
        if (string.find(i,str) or string.find(i,str:lower())) and string.StartWith(v,"<dea") then
          tabele[i] = v
        end
      end
    else
      for i,v in pairs(chathud.Shortcuts) do
        if string.find(i,str) or string.find(i,str:lower()) then
          tabele[i] = v
        end
      end
    end
  else
    tabele = chathud.Shortcuts
  end
  for i,v in pairs(tabele) do
    coroutine.yield()
    local kek = vgui.Create("DButton",base)
    kek:SetText(i)
    kek:SetTall(35)
    kek:SetTextColor(Color(255,255,255,255))
    kek:SetContentAlignment(4)
    kek:Dock(TOP)
    kek.DoClick = function()
      LocalPlayer():ConCommand("say :" .. i .. ":")
    end
    local m = Matrix()
    local textm = class:new("Markup")
    textm.x = menu:GetWide() -64
    textm.w = kek:GetWide()
    textm:Parse(v)
    kek.Paint = function(self,w,h)
      surface.SetDrawColor(Color(20,0,0,200))
      surface.DrawRect(0,0,w,h)
      m:SetTranslation(Vector(textm.x,textm.y))
      cam.PushModelMatrix(m)
      textm:Draw()
      cam.PopModelMatrix()
    end
  end
  loaded = true
end
local filtrstr = nil
local co

local function loademotes()
  if loaded then hook.Remove("Think","LoadEmotes") end
  if not co or not coroutine.resume(co) then
    co = coroutine.create(function() loaddata(filtrstr) end)
    coroutine.resume(co)
  end
end
hook.Add("Think","LoadEmotes",function()
loademotes()
end)

filter.OnChange = function()
local val = filter:GetValue()
local streng
streng = val
if val:trim() == "" then streng = nil end

hook.Remove("Think","LoadEmotes")
base:Remove()
base = vgui.Create("DScrollPanel",menu)
base:Dock(FILL)
loaded = false
filtrstr = streng
co = nil
hook.Add("Think","LoadEmotes",loademotes)
end

menu.OnClose = function()
menu:Remove()
hook.Remove("Think","LoadEmotes")
end
end
concommand.Add("emotes_list",OpenEmoteGui)
--if LocalPlayer():Name() == "Jak Ci DÅ‚ugi Nick Przeszkadza" then OpenEmoteGui() end


end
