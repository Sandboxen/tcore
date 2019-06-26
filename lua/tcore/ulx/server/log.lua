function logtool(ply, tr, tool)
	if tool != "inflator" and tool != "paint" then
		ulx.logSpawn( ply:Nick() .. "<" .. ply:SteamID() .. "> used the tool " .. tool .. " on " .. tr.Entity:GetModel() )
	end
end
hook.Add( "CanTool", "ToolLogging", logtool )
--hook.Remove("CanTool","ToolLogging") -- disable