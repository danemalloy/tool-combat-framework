--!strict

-- services
local Replicated = game:GetService("ReplicatedStorage")
local Server = game:GetService("ServerScriptService")

-- modules
local network = require(Replicated.framework.modules.network)
local hitbox = require(Server.framework.modules.hitbox)

-- libs
local movesets = require(Replicated.framework.libs.movesets)

-- anims
local animation1 = Instance.new("Animation")
animation1.AnimationId = movesets["fists"]["combo"]["AnimationId1"]
local animation2 = Instance.new("Animation")
animation2.AnimationId = movesets["fists"]["combo"]["AnimationId2"]
local animation3 = Instance.new("Animation")
animation3.AnimationId = movesets["fists"]["combo"]["AnimationId3"]

local module = {}

module.combo = function(player: Player)
	if (not player:GetAttribute("CanFight")) then return end
	if (DateTime.now().UnixTimestampMillis - player:GetAttribute("LastEnd") < 1500) then
		return
	end
	
	local character = player.Character
	assert(character~=nil, "character must be present for combo!")
	local human = character:FindFirstChild("Humanoid") :: Humanoid
	local root = character:FindFirstChild("HumanoidRootPart") :: BasePart
	local animator = human:FindFirstChild("Animator") :: Animator
	
	if (not root) or (not human) or (not animator) then warn("no root, human, or animator") return end
	
	local moveset = player:GetAttribute("Moveset")
	local combo = player:GetAttribute("Combo")
	
	if (player:GetAttribute("Moveset") ~= "fists") then warn("player does not have fists equipped") return end
	
	if (combo == 1) then
		player:SetAttribute("CanFight", false)
		player:SetAttribute("Combo", player:GetAttribute("Combo")+1)
		player:SetAttribute("Last", DateTime.now().UnixTimestampMillis)
		local animation = animator:LoadAnimation(animation1)
		animation:Play()
		
		animation:GetMarkerReachedSignal("hit"):Connect(function()
			hitbox.create(
				player,
				"combo",
				root.CFrame * CFrame.new(0,0,-3),
				movesets["fists"]["combo"]["Hitbox"],
				movesets["fists"]["combo"]["Damage"]
			)
		end)
		
		animation.Stopped:Connect(function()
			task.wait(movesets["fists"]["combo"]["EndLag"])
			player:SetAttribute("CanFight", true)
		end)
	elseif (combo == 2) then
		player:SetAttribute("CanFight", false)
		player:SetAttribute("Combo", player:GetAttribute("Combo")+1)
		player:SetAttribute("Last", DateTime.now().UnixTimestampMillis)
		
		local animation = animator:LoadAnimation(animation2)
		animation:Play()
		
		animation:GetMarkerReachedSignal("hit"):Connect(function()
			hitbox.create(
				player,
				"combo",
				root.CFrame * CFrame.new(0,0,-3),
				movesets["fists"]["combo"]["Hitbox"],
				movesets["fists"]["combo"]["Damage"]
			)
		end)
		
		animation.Stopped:Connect(function()
			task.wait(movesets["fists"]["combo"]["EndLag"])
			player:SetAttribute("CanFight", true)
		end)
	elseif (combo == 3) then
		local last = DateTime.now().UnixTimestampMillis
		player:SetAttribute("CanFight", false)
		player:SetAttribute("Combo", 1)
		player:SetAttribute("Last", last)
		player:SetAttribute("LastEnd", last)
		
		local animation = animator:LoadAnimation(animation3)
		animation:Play()
		
		animation:GetMarkerReachedSignal("hit"):Connect(function()
			hitbox.create(
				player,
				"combo",
				root.CFrame * CFrame.new(0,0,-3),
				movesets["fists"]["combo"]["Hitbox"],
				movesets["fists"]["combo"]["Damage"]
			)
		end)
		
		animation.Stopped:Connect(function()
			task.wait(movesets["fists"]["combo"]["EndLag"])
			player:SetAttribute("CanFight", true)
		end)
	end
end

module.stomp = function(player: Player)
	print(`{player.Name} stomp`)
end

return module
