--!strict

--[[
	@server
	author: dane (dane1up)
	
	main server handler for all modules in the game
]]--

-- services
local Server = game:GetService("ServerScriptService")

-- init modules
for _, module: ModuleScript in Server.framework.preload:GetChildren() do
	local name = module.Name
	print(`[SERVER] loading {name}`)
	local module = require(module) :: any
	repeat
		task.wait()
	until module.loaded
	print(`[SERVER] {name} loaded successfully`)
end

print(`[SERVER] all modules loaded successfully✅`)
