file.CreateDir("downloaded_assets")

local exists = file.Exists
local write = file.Write
local fetch = http.Fetch
local white = Color( 255, 255, 255 )
local surface = surface
local crc = util.CRC
local _error = Material("error")
local math = math
local mats = {}
local fetchedavatars = {}

local function fetch_asset(url)
	if not url then return _error end

	if mats[url] then
		return mats[url]
	end

	local crc = crc(url)

	if exists("downloaded_assets/" .. crc .. ".png", "DATA") then
		mats[url] = Material("data/downloaded_assets/" .. crc .. ".png")

		return mats[url]
	end

	mats[url] = _error

	fetch(url, function(data)
		write("downloaded_assets/" .. crc .. ".png", data)
		mats[url] = Material("data/downloaded_assets/" .. crc .. ".png")
	end)

	return mats[url]
end

local function fetchAvatarAsset( id64, size )
	id64 = id64 or "BOT"
	size = size == "medium" and "medium" or size == "small" and "" or size == "large" and "full" or ""

	if fetchedavatars[ id64 .. " " .. size ] then
		return fetchedavatars[ id64 .. " " .. size ]
	end


	fetchedavatars[ id64 .. " " .. size ] = id64 == "BOT" and "http://steamcdn-a.akamaihd.net/steamcommunity/public/images/avatars/09/09962d76e5bd5b91a94ee76b07518ac6e240057a_full.jpg" or "http://i.imgur.com/uaYpdq7.png"
	if id64 == "BOT" then return end
	fetch("http://steamcommunity.com/profiles/" .. id64 .. "/?xml=1",function( body )
		local urlsize = size:sub(1,1):upper()..size:sub(2)

		local link3 = XMLToTable(body)["profile"]["avatar"..urlsize]

if link3 then

		fetchedavatars[ id64 .. " " .. size ] = link3
		--print(fetchedavatars[ id64 .. " " .. size ])
	else
		return
	end
	end)
end

function draw.WebImage( url, x, y, width, height, color, angle, cornerorigin )
	color = color or white

	surface.SetDrawColor( color.r, color.g, color.b, color.a )
	surface.SetMaterial( fetch_asset( url ) )
	if not angle then
		surface.DrawTexturedRect( x, y, width, height)
	else
		if not cornerorigin then
			surface.DrawTexturedRectRotated( x, y, width, height, angle )
		else
			surface.DrawTexturedRectRotated( x + width / 2, y + height / 2, width, height, angle )
		end
	end
end

function draw.SeamlessWebImage( url, parentwidth, parentheight, xrep, yrep, color )
	color = color or white
	local xiwx, yihy = math.ceil( parentwidth/xrep ), math.ceil( parentheight/yrep )
	for x = 0, xrep - 1 do
		for y = 0, yrep - 1 do
			draw.WebImage( url, x*xiwx, y*yihy, xiwx, yihy, color )
		end
	end
end

function draw.SteamAvatar( avatar, res, x, y, width, height, color, ang, corner )
	draw.WebImage( fetchAvatarAsset( avatar, res ), x, y, width, height, color, ang, corner )
end
function draw.Circle( x, y, radius, seg )
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 ) -- This is needed for non absolute segment counts
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
end
function draw.CircularWebImage(url,x,y,radius,seg,color)
color = color or white

	surface.SetDrawColor( color.r, color.g, color.b, color.a )
	surface.SetMaterial( fetch_asset( url ) )
	if not angle then
		draw.Circle(x,y,radius,seg)
		--surface.DrawTexturedRect( x, y, width, height)
	else
		if not cornerorigin then
			draw.Circle(x,y,radius,seg)
			--surface.DrawTexturedRectRotated( x, y, width, height, angle )
		else
			draw.Circle(x+width/2,y+height/2,radius,seg)
			--surface.DrawTexturedRectRotated( x + width / 2, y + height / 2, width, height, angle )
		end
	end
end
function draw.CircularSteamAvatar(avatar,res,x,y,radius,seg,color)
draw.CircularWebImage( fetchAvatarAsset( avatar, res ), x, y,radius,seg,color)
end
return true