function logtool(ply, tr, tool)
	if tool != "inflator" then
		ulx.logSpawn( ply:Nick() .. "<" .. ply:SteamID() .. "> used the tool " .. tool .. " on " .. tr.Entity:GetModel() )
	end
end
hook.Add( "CanTool", "ToolLogging", logtool )
