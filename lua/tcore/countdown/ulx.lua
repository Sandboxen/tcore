function ulx.countdown(calling_ply,time,reason)
if SERVER then
startCountdown(reason,time,function() 
end)
end
ulx.fancyLogAdmin( calling_ply, "#A started countdown.")
end
local countdown = ulx.command("Utility", "ulx countdown", ulx.countdown, "!countdown", false, false, true )
countdown:addParam{ type=ULib.cmds.NumArg ,hint="How Much"}
countdown:addParam{ type=ULib.cmds.StringArg ,hint="Message"}
countdown:defaultAccess( ULib.ACCESS_ADMIN )
countdown:help( "Starts countdown." )