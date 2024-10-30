--!strict

-- services
local Debris = game:GetService("Debris")
local Players = game:GetService("Players")

-- player
local player = Players.LocalPlayer

local module = {}

module.combo = function(damagingPlayer: Player, hitCharacter: Model)
	if (not hitCharacter) then return end
	
	if (damagingPlayer == player) then
		task.spawn(function()
			local highlight = Instance.new("Highlight")
			highlight.DepthMode = Enum.HighlightDepthMode.Occluded
			highlight.OutlineTransparency = 0
			highlight.OutlineColor = Color3.new(0.666667, 0, 0)
			highlight.FillColor = Color3.new(1, 0, 0)
			highlight.FillTransparency = 0.65
			highlight.Parent = hitCharacter

			Debris:AddItem(highlight, 0.5)
		end)
	end
end

return module
