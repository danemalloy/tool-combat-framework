--!strict

--[[
	@prompts
	author: dane (dane1up)
	
	handles all the prompts in the game
]]--

-- services
local Collection = game:GetService("CollectionService")

local module = {}
local types = {}

for _, action: ModuleScript in script:GetChildren() do
	types[action.Name] = require(action) :: any
end

for _, prompt: ProximityPrompt in Collection:GetTagged("Prompt") do
	local promptType = prompt:GetAttribute("Type") :: string
	if (not promptType) then continue end
	if (not types[promptType]) then continue end
	types[promptType](prompt)
end

module.loaded = true

return module
