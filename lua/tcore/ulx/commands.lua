hook.Add("ULXLoaded","tcoreload",function()
    function ulx.addony( calling_ply)
        calling_ply:SendLua([[gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=1443560861")]])
    end
    local addony = ulx.command( "Linki", "ulx addony", ulx.addony, "!addony" )
    --addony:defaultAccess( ULib.ACCESS_ADMIN )
    addony:help( "Lista addonów" )
    function ulx.grupa( calling_ply)
        calling_ply:SendLua([[gui.OpenURL("https://steamcommunity.com/groups/polskisandbox")]])
    end
    local grupa = ulx.command( "Linki", "ulx grupa", ulx.grupa, "!grupa" )
    --grupa:defaultAccess( ULib.ACCESS_ADMIN )
    grupa:help( "Grupa" )
    function ulx.decals( calling_ply)
        BroadcastLua([[LocalPlayer():ConCommand("r_cleardecals")]])
        BroadcastLua([[
            for k, v in pairs(ents.FindByClass("class C_ClientRagdoll")) do
            if IsValid(v) then
            v:Remove()
            end
            end
        ]])
        ulx.fancyLogAdmin( calling_ply, "#A cleaned up decals.", affected_plys )
    end
    local decals = ulx.command( "Utility", "ulx decals", ulx.decals, "!decals" )
    decals:defaultAccess( ULib.ACCESS_ADMIN )
    decals:help( "Decals" )
    function ulx.cleanup( calling_ply)
        game.CleanUpMap()
        ulx.fancyLogAdmin( calling_ply, "#A cleaned up map.", affected_plys )
    end
    local cleanup = ulx.command( "Utility", "ulx cleanup", ulx.cleanup, "!cleanup" )
    cleanup:defaultAccess( ULib.ACCESS_ADMIN )
    cleanup:help( "Cleanup" )
    function ulx.tcleanup( calling_ply)
        startCountdown("CleanUP",60,game.CleanUpMap)
        ulx.fancyLogAdmin( calling_ply, "#A started cleanupcountdown.", affected_plys )
    end
    local tcleanup = ulx.command( "Utility", "ulx tcleanup", ulx.tcleanup, "!tcleanup" )
    tcleanup:defaultAccess( ULib.ACCESS_ADMIN )
    tcleanup:help( "Cleanup" )

    function ulx.build(calling_ply)
        calling_ply:SetBuildMode(true)
        ulx.fancyLogAdmin( calling_ply, "#A zmienil tryb na Build.", affected_plys )
    end
    local build = ulx.command("Buildmode", "ulx build", ulx.build, "!build")
    build:defaultAccess(ULib.ACCESS_ADMIN)
    build:help("Buildmode")

    function ulx.unbuild(calling_ply)
        calling_ply:SetBuildMode(false)
        ulx.fancyLogAdmin( calling_ply, "#A zmienil tryb na PVP.", affected_plys )
    end
    local unbuild = ulx.command("Buildmode", "ulx pvp", ulx.unbuild, "!pvp")
    unbuild:defaultAccess(ULib.ACCESS_ADMIN)
    unbuild:help("Buildmode")
end)
if SERVER then
    game.OldConsoleCommand = game.OldConsoleCommand or game.ConsoleCommand
    function game.ConsoleCommand(str)
        if string.StartWith(str,"changelevel") then
        startCountdown("Zmiana Mapy na "..string.sub(str,13),60,function()
        game.OldConsoleCommand(str)
        end)
        else
        game.OldConsoleCommand(str)
        end
    end
    ULib.consoleCommand = game.ConsoleCommand
end
hook.GetTable().ULXLoaded.tcoreload()