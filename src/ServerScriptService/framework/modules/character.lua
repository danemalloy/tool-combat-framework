--!strict

--[[
	@character
	author: dane (dane1up)
	
	handles all player characters
]]--

-- services
local Players = game:GetService("Players")
local Replicated = game:GetService("ReplicatedStorage")
local Run = game:GetService("RunService")

-- modules
local network = require(Replicated.framework.modules.network)
local profileTemplate = require(Replicated.framework.libs.playerDataTemplate) -- for type checking

-- methods
local module = {}

module.characterAdded = function(player: Player, data: profileTemplate.PlayerDataTemplate)
	repeat
		task.wait()
	until player.Character
	
	local character = player.Character or player.CharacterAdded:Wait()
	local human = character:WaitForChild("Humanoid") :: Humanoid
	
	local moveset = data.activeMoveset
	
	player:SetAttribute("CanFight", true)
	player:SetAttribute("Combo", 1)
	player:SetAttribute("Last", 0)
	player:SetAttribute("Equipped", false)
	player:SetAttribute("Moveset", moveset)
	player:SetAttribute("LastEnd", 0)
	
	local connection

	connection = Run.Heartbeat:Connect(function()
		if (DateTime.now().UnixTimestampMillis - player:GetAttribute("Last") >= 3000) and (player:GetAttribute("Combo") > 1) then
			player:SetAttribute("Combo", 1)
		end
	end)

	human.Died:Connect(function()
		if (not connection) then return end
		connection:Disconnect()
	end)

	Players.PlayerRemoving:Connect(function(left)
		if (left ~= player) then return end
		if (not connection) then return end
		connection:Disconnect()
	end)
	
	print("[SERVER] player attributes set successfully")
end

return module
