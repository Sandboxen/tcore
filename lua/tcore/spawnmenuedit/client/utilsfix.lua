--from https://github.com/Re-Dream/misc/blob/master/lua/autorun/client/spawnmenu_tool_categories.lua

spawnmenu._AddToolMenuOption = spawnmenu._AddToolMenuOption or spawnmenu.AddToolMenuOption
spawnmenu._AddToolCategory   = spawnmenu._AddToolCategory or spawnmenu.AddToolCategory

local redirect = function(tab)
	if tab:lower() == "options" then return "Utilities" end
	return tab
end

spawnmenu.AddToolMenuOption = function(tab, ...)
	spawnmenu._AddToolMenuOption(redirect(tab), ...)
end
spawnmenu.AddToolCategory = function(tab, ...)
	spawnmenu._AddToolCategory(redirect(tab), ...)
end