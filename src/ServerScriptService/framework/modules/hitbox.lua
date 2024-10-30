--!strict

--[[
	@character
	author: dane (dane1up)
	
	handles all hitboxes
]]--

-- services
local _Workspace = game:GetService("Workspace")
local Replicated = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- modules
local network = require(Replicated.framework.modules.network)

local module = {}

module.create = function(player: Player, set: string, position: CFrame, size: Vector3, damage: number)
	local character = player.Character
	if (not character) then return end
	
	local params = OverlapParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = _Workspace.safezone:GetDescendants()
	
	local result = _Workspace:GetPartBoundsInBox(position, size, params)
	local hitPlayers = {}
	for _, hitPart: BasePart in result do
		if (not hitPart.Parent) then continue end
		if (hitPart.Parent == character) then continue end
		if hitPlayers[hitPart.Parent] then continue end
		local hitHuman = hitPart.Parent:FindFirstChildOfClass("Humanoid")
		if (not hitHuman) then continue end
		if (hitHuman.Health <= 0) then continue end
		
		hitPlayers[hitPart.Parent] = true
		hitHuman.Health -= damage
		
		for _, replicator in Players:GetPlayers() do
			local replicatorChar = replicator.Character
			local replicatorRoot = replicatorChar.PrimaryPart
			local characterRoot = character.PrimaryPart
			
			if (not characterRoot) or (not replicatorRoot) then continue end
			
			if (characterRoot.Position - replicatorRoot.Position).Magnitude <= 200 then -- for optimization purposes (only show vfx if in range)
				network.sendClient(
					replicator,
					"replicate",
					{
						["Move"] = player:GetAttribute("Moveset"),
						["Set"] = set,
						["hitCharacter"] = hitPart.Parent,
						["damagingPlayer"] = player
					}
				)
			end
		end
	end
end

return module
