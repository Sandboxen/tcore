local function FindHeadPos(ent)
		if ent.findheadpos_last_mdl ~= ent:GetModel() then
			ent.findheadpos_head_bone = nil
			ent.findheadpos_head_attachment = nil
			ent.findheadpos_last_mdl = ent:GetModel()
		end

		if not ent.findheadpos_head_bone then
			for i = 0, ent:GetBoneCount() or 0 do
				local name = ent:GetBoneName(i):lower()
				if name:find("head", nil, true) then
					ent.findheadpos_head_bone = i
					break
				end
			end
		end

		if ent.findheadpos_head_bone then
			local m = ent:GetBoneMatrix(ent.findheadpos_head_bone)
			if m then
				local pos = m:GetTranslation()
				if pos ~= ent:GetPos() then
					return pos, m:GetAngles()
				end
			end
		else
			if not ent.findheadpos_attachment_eyes then
				ent.findheadpos_head_attachment = ent:GetAttachments().eyes or ent:GetAttachments().forward
			end

			if ent.findheadpos_head_attachment then
				local angpos = ent:GetAttachment(ent.findheadpos_head_attachment)
				return angpos.Pos, angpos.Ang
			end
		end

		return ent:EyePos(), ent:EyeAngles()
	end




local texts = {}
function string.wrapwords(Str,width,font)
if ( font ) then
surface.SetFont( font )
end
local tbl, len, Start, End = {}, string.len( Str ), 1, 1
while ( End < len ) do
End = End + 1
if ( surface.GetTextSize( string.sub( Str, Start, End ) ) > width ) then
local n = string.sub( Str, End, End )
local I = 0
for i = 1, 15 do
I = i
if ( n ~= " " and n ~= "," and n ~= "." and n ~= "\n" ) then
End = End - 1
n = string.sub( Str, End, End )
else break end
end
if ( I == 15 ) then
End = End + 14 end
local FnlStr = string.Trim( string.sub( Str, Start, End ) )
table.insert( tbl, FnlStr )
Start = End + 1 end
end
table.insert( tbl, string.sub( Str, Start, End ) )
return tbl
end
function shitdraw()
for k,v in ipairs(texts) do
if IsValid(v.ply) then
local w,h = surface.GetTextSize(table.concat( string.wrapwords(v.text,500,"ChatFont"),"\n"))
local ply = v.ply
surface.SetFont("ChatFont")
if v.move == true then
v.pos = FindHeadPos(ply)
v.ang = select(2,FindHeadPos(ply))
end
if v.move == true and ply.typing == false then
v.alpha = 0
v.shouldhide = true
end
cam.Start3D2D(v.pos + Vector(0,0,20 + h / 10),Angle(0,v.ang.y + 90,90),0.1)
if CurTime() > v.hidetime and v.shouldhide == true then v.hiding = true end
if v.hiding == true then v.alpha = v.alpha - 10 end
if v.alpha < 10 then table.RemoveByValue(texts,v) end
surface.SetDrawColor(Color(255,255,255,v.alpha))
surface.SetTextPos(5,5)
surface.SetTextColor(Color(255,255,255,v.alpha))
surface.SetDrawColor(Color(30,30,30,250 * (v.alpha / 255)))
surface.DrawRect(0-w / 2,0,w + 10,h + 10)
surface.SetDrawColor(66,66,66,240 * v.alpha / 255)
surface.DrawOutlinedRect(0-w / 2,0,w + 10,h + 10)
for i,wrap in ipairs( string.wrapwords(v.text,500,"ChatFont")) do
local _,lh = surface.GetTextSize(wrap)
surface.SetTextPos(5-w / 2,5 + (i-1) * lh / 1.22)
surface.DrawText(wrap)
end
cam.End3D2D()
end
end
end
hook.Add("PreDrawEffects","ChatOnHead",shitdraw)
--hook.Remove("PreDrawEffects","ChatOnHead")
local plytexts = {}
function overHeadText(txt,ply,move,hide,shouldhide)

local hidetime
if hide then
hidetime = CurTime() + hide
else
hidetime = CurTime() + 5
end
if move == nil then move = false end
if shouldhide == nil then shouldhide = true end
local id = #texts + 1

local pos = FindHeadPos(ply)
local ang = select(2,FindHeadPos(ply))
local text = {id = id,hidetime = hidetime,text = txt,ply = ply,pos = pos,ang = ang ,alpha = 255,hiding = false,move = move,shouldhide = shouldhide}
table.insert(texts,text)
return text

end

net.Receive("ChatOnHeadUpdateText",function()
local ply = net.ReadEntity()
local text = net.ReadString()
if IsValid(ply) and string.Trim(text) ~= "" then
local chattext = plytexts[ply] or overHeadText(text,ply,true,0,false)
chattext.text = text
plytexts[ply] = chattext
end
end)
net.Receive("ChatOnHeadStartChat",function()
local ply = net.ReadEntity()
if IsValid(ply) then
ply.typing = true
--plytexts[ply] = overHeadText("",ply,true,0,false)
end
end)
net.Receive("ChatOnHeadFinishChat",function()
local ply = net.ReadEntity()
if IsValid(ply) and plytexts[ply] then
plytexts[ply].alpha = 0
plytexts[ply].shouldhide = true
plytexts[ply] = nil
end
ply.typing = false
end)

hook.Add("ChatTextChanged","ChatOnHead",function(s)
if typing == true then
net.Start("ChatOnHeadUpdateText")
net.WriteString(s)
net.SendToServer()
end
end)

hook.Add("StartChat","ChatOnHead",function()
typing = true

net.Start("ChatOnHeadStartChat")
net.SendToServer()
end)
hook.Add("FinishChat","ChatOnHead",function()
typing = false
if plytexts[LocalPlayer()] then
plytexts[LocalPlayer()].alpha = 0
end
net.Start("ChatOnHeadFinishChat")
net.SendToServer()
end)