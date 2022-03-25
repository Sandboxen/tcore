local maps = file.Find( "maps/*.bsp", "GAME" )
local maplist = {}
for _, map in ipairs( maps ) do
    local mapname = map:sub( 1, -5 ):lower()
    if string.StartWith(mapname,"gm_") then
            table.insert(maplist,mapname)
    end
    local data = util.TableToJSON(maplist)
    file.Write("maps.json",data)
end