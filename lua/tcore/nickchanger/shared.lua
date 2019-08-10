local meta = FindMetaTable("Player")
local sitestoremove = {}
local sites = {
"CSGO-SKINS.COM",
"OPENSKINS.COM",
"hellcase.com",
"cgsoempire.com",
"Pvpro.com",
"dogry.pl",
"opencase.com",
"zgame.pl",
"Key-drop.pl",
"Key-Drop.pl",
}
for i,v in ipairs(sites) do
sitestoremove[#sitestoremove + i] = " " .. v
end
for i,v in ipairs(sites) do
sitestoremove[#sitestoremove + i] = v .. " "
end
for i,v in ipairs(sites) do
sitestoremove[#sitestoremove + i] = v
end
for i,v in ipairs(sites) do
sitestoremove[#sitestoremove + i] = v:lower()
end
for i,v in ipairs(sites) do
sitestoremove[#sitestoremove + i] = v:upper()
end
meta.OldNick = meta.OldNick or meta.Nick
function meta:Nick( b_realnick )
	if b_realnick then
		local nick = self:OldNick()
		return nick
	else
		if IsValid(self) then
			local nick = self:OldNick()
			if self:GetNWString("fake_name","") != "" then
			nick = self:GetNWString("fake_name","")
			end
			if not nick then nick = self:OldNick() end
			for i,v in ipairs(sitestoremove) do
				nick = string.Replace(nick,v,"")
			end
			return nick
		end
	end
end
meta.Name = meta.Nick
meta.GetName = meta.Nick
