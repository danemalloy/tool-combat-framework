--!strict

--[[
	@weapon
	author: dane (dane1up)
	
	handles all weapon connections on the server
]]--

-- services
local Replicated = game:GetService("ReplicatedStorage")
local Server = game:GetService("ServerScriptService")

-- modules
local network = require(Replicated.framework.modules.network)

local module = {}
local moves = {}

module._handleEvent = function(player: Player, ...)
	local data = ...
	if (not data["Move"]) then warn("no move") return end
	local move = data["Move"]
	local set = data["Set"]
	if (moves[move] and moves[move][set]) then
		moves[move][set](player)
	end
end

-- connections
network.add("equip", function(player: Player)
	local character = player.Character
	if (not character) then warn("no character") return end
	character:SetAttribute("Equipped", true)
end)

network.add("unequip", function(player: Player)
	local character = player.Character
	if (not character) then warn("no character") return end
	character:SetAttribute("Equipped", false)
end)

network.add("handleAction", function(player: Player, ...: any)
	module._handleEvent(player, ...)
end)

-- init
for _, move: ModuleScript in Server.framework.moves:GetChildren() do
	if not move:IsA("ModuleScript") then continue end
	moves[move.Name] = require(move) :: any
end

module.loaded = true

return module
