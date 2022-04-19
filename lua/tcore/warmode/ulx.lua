function ulx.warmode(calling_ply,time,reason)
    if not GetGlobalBool("wojenna",false) then
        RunConsoleCommand("ACF_SetPermissionMode","battle")
        RunConsoleCommand("wire_expression2_extension_disable","playercore")
        RunConsoleCommand("wire_expression2_extension_disable","nexuscore")
        RunConsoleCommand("sbox_noclip",0)
        RunConsoleCommand("kylebuildmode_allownoclip",0)
        SetGlobalBool("wojenna",true)
        ulx.fancyLogAdmin( calling_ply, "#A wprowadzil stan wojenny.")
    else
        RunConsoleCommand("ACF_SetPermissionMode","build")
        RunConsoleCommand("wire_expression2_extension_enable","playercore")
        RunConsoleCommand("wire_expression2_extension_enable","nexuscore")
        RunConsoleCommand("sbox_noclip",1)
        RunConsoleCommand("kylebuildmode_allownoclip",1)
        SetGlobalBool("wojenna",false)
        ulx.fancyLogAdmin( calling_ply, "#A wylaczyl stan wojenny.")
    end
end
local countdown = ulx.command("Utility", "ulx wojenna", ulx.warmode, "!wojenna", false, false, true )
countdown:defaultAccess( ULib.ACCESS_ADMIN )
countdown:help( "Przełącza wojenną." )