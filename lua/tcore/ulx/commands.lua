hook.Add("ULXLoaded","tcoreload",function()
function ulx.addony( calling_ply, sound )
    calling_ply:SendLua([[gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=1443560861")]])
end
local addony = ulx.command( "Linki", "ulx addony", ulx.addony, "!addony" )
--addony:defaultAccess( ULib.ACCESS_ADMIN )
addony:help( "Plays a sound (relative to sound dir)." )
function ulx.grupa( calling_ply, sound )
    calling_ply:SendLua([[gui.OpenURL("https://steamcommunity.com/groups/polskisandbox")]])
end
local grupa = ulx.command( "Linki", "ulx grupa", ulx.grupa, "!grupa" )
--grupa:defaultAccess( ULib.ACCESS_ADMIN )
grupa:help( "Plays a sound (relative to sound dir)." )
end)