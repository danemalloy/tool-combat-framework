--!strict

--[[
	@replicator
	author: dane (dane1up)
	
	client replicator for server vfx and sfx
]]--

-- services
local Players = game:GetService("Players")
local Replicated = game:GetService("ReplicatedStorage")

-- player
local player = Players.LocalPlayer

-- yield
repeat
	task.wait()
until player.Character

-- modules
local network = require(Replicated.framework.modules.network)

local module = {}
local moves = {}

-- connection
network.add("replicate", function(...)
	local data = ...
	if (not data["Move"]) then warn("no move") return end
	local move = data["Move"]
	local set = data["Set"]
	local hitCharacter = data["hitCharacter"]
	local damagingPlayer = data["damagingPlayer"]
	if (moves[move] and moves[move][set]) then
		moves[move][set](damagingPlayer, hitCharacter)
	end
end)

-- init
for _, move: ModuleScript in script.Parent.Parent.moves:GetChildren() do
	if (not move:IsA("ModuleScript")) then continue end
	moves[move.Name] = require(move) :: any
end

module.loaded = true

return module
