hook.Add("ULXLoaded","tcoreload",function()
function ulx.addony( calling_ply, sound )
    calling_ply:SendLua([[gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=1443560861")]])
end
local addony = ulx.command( "Linki", "ulx addony", ulx.addony, "!addony" )
--addony:defaultAccess( ULib.ACCESS_ADMIN )
addony:help( "Plays a sound (relative to sound dir)." )
end)