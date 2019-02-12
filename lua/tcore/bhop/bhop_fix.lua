hook.Add("Initialize", "bunnyhop_fix", function()
	function GAMEMODE:StartMove(ply, mv)
		if drive.StartMove(ply, mv) then return true end
	end
	function GAMEMODE:FinishMove(ply, mv)
		if drive.FinishMove(ply, mv) then return true end
	end
end)