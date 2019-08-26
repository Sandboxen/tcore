local tag = "geoip"

local PLAYER = FindMetaTable("Player")

if SERVER then
	--if not GeoIP then local ok = pcall(require, "geoip") if not ok then return end end
	hook.Add("PlayerInitialSpawn",tag,function(ply)
	if ply:IsBot() then return end
	local ip = ply:IPAddress():match("(.*):%d+$")
		http.Fetch("http://ip-api.com/json/"..ip,function(bd)
		local data = util.JSONToTable(bd)
		ply:SetNWString("country_data",bd)
		ply:SetNWString("country_code",data.countryCode)
		ply:SetNWString("country_name",data.country)
		ply:SetNWString("city",data.city)
		end)
	end)
	function PLAYER:GetCountryData()
		return util.JSONToTable(self:GetNWString("country_data"))
	end

	function PLAYER:GetCountry() return self:GetNWString("country_name") end
	function PLAYER:GetCountryCode() return self:GetNWString("country_code") end
	function PLAYER:GetCity() return self:GetNWString("city") end

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