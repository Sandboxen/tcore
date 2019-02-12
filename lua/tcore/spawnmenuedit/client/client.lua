local TabsToRemove = {
	["spawnmenu.category.saves"] = 1,
	--["spawnmenu.category.dupes"] = 1,
	--["spawnmenu.category.postprocess"] = 1,
	--["KOPJE"]=1,
		-- ["#spawnmenu.content_tab"] = 1,
}

local function DestroySpawnTabs()
	local GetCreationTabs = spawnmenu.GetCreationTabs
	local SpawnMenu = g_SpawnMenu.CreateMenu

	for k,_ in next, TabsToRemove do
		GetCreationTabs()['#' .. k] = nil -- Check for both language,
		GetCreationTabs()[k] = nil      -- and literal definitions.
		for _,v in pairs( SpawnMenu.Items ) do
			if v.Tab:GetText() == k or v.Tab:GetText() == language.GetPhrase(k) then
				SpawnMenu:CloseTab( v.Tab, true ) -- Due to some wierd gmod magic, the above sometimes doesn't work and vise vera.
			end                                       -- Including both for a higher chance of working.
		end
	end
end
hook.Add("SpawnMenuOpen", "RemoveSpawnmenuTabs", DestroySpawnTabs)