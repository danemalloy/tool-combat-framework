--!strict

--[[
	@server
	author: dane (dane1up)
	
	main server handler for all modules in the game
]]--

-- services
local Replicated = game:GetService("ReplicatedStorage")
local StarterCharacterScripts = script.Parent.Parent.Parent

-- network
local network = require(Replicated.framework.modules.network)

local loaded = false
network.add("loaded", function()
	loaded = true
end)

local start = os.clock()
repeat
	task.wait()
until loaded or (os.clock() - start > 20)

-- init modules
for _, module: ModuleScript in StarterCharacterScripts.framework.preload:GetChildren() do
	local name = module.Name
	print(`[CLIENT] loading {name}`)
	local module = require(module) :: any
	repeat
		task.wait()
	until module.loaded
	print(`[CLIENT] {name} loaded successfully`)
end

print(`[CLIENT] all modules loaded successfully✅`)
