local tag = "geoip"

local PLAYER = FindMetaTable("Player")

if SERVER then
	if not GeoIP then local ok = pcall(require, "geoip") if not ok then return end end

	function PLAYER:GetCountryData()
		return GeoIP.Get(self:IPAddress():match("(.*):%d+$"))
	end

	function PLAYER:GetCountry() return self:GetCountryData().country_name end
	function PLAYER:GetCountryCode() return self:GetCountryData().country_code end
	function PLAYER:GetCity() return self:GetCountryData().city end

	hook.Add("PlayerInitialSpawn", tag, function(ply)
		if ply:IsBot() then return end

		ply:SetNWString("country_name", ply:GetCountry())
		ply:SetNWString("country_code", ply:GetCountryCode())
		ply:SetNWString("city", ply:GetCity())
	end)

	if istable(GAMEMODE) then
		for _, ply in next, player.GetAll() do
			hook.GetTable().PlayerInitialSpawn[tag](ply)
		end
	end
else
	function PLAYER:GetCountry() return self:GetNWString("country_name") end
	function PLAYER:GetCountryCode() return self:GetNWString("country_code") end
	function PLAYER:GetCity() return self:GetNWString("city") end
end