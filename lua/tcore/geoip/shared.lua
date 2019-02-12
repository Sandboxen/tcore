local url = "http://ip-api.com/json/"
local tag = "geoip"

local PLAYER = FindMetaTable("Player")

if SERVER then

local cache = {}

local function getPlyData(ply)
    http.Fetch(url .. ply:IPAddress():match("(.*):%d+$"),function(bd)
        local data = {}
        local response = util.JSONToTable(bd)
        if response.status and response.status == "success" then
            data.city = response.city
            data.country_name = response.country
            data.country_code = response.countryCode
            cache[ply] = data
            ply:SetNWString("country_name", ply:GetCountry())
            ply:SetNWString("country_code", ply:GetCountryCode())
            ply:SetNWString("city", ply:GetCity())
        end
    end)
end

local function requestUpdate(ply)
if IsValid(ply) and !ply:IsBot() then
        getPlyData(ply)
else
    for _,plys in ipairs(player.GetAll()) do
        getPlyData(plys)
    end
end
end

function PLAYER:GetCountryData()
    if (cache[self]) then
        return cache[self]
    else
        requestUpdate()
        return {country_name = "", country_code = "", city = ""}
    end
end

function PLAYER:GetCountry() return self:GetCountryData().country_name end
function PLAYER:GetCountryCode() return self:GetCountryData().country_code end
function PLAYER:GetCity() return self:GetCountryData().city end

hook.Add("PlayerInitialSpawn", tag, function(ply)
    requestUpdate(ply)
    if ply:IsBot() then return end

    ply:SetNWString("country_name", ply:GetCountry())
    ply:SetNWString("country_code", ply:GetCountryCode())
    ply:SetNWString("city", ply:GetCity())
end)

if istable(GAMEMODE) then
    requestUpdate()
    for _, ply in next, player.GetAll() do
        hook.GetTable().PlayerInitialSpawn[tag](ply)
    end
end
else
function PLAYER:GetCountry() return self:GetNWString("country_name") end
function PLAYER:GetCountryCode() return self:GetNWString("country_code") end
function PLAYER:GetCity() return self:GetNWString("city") end
end
