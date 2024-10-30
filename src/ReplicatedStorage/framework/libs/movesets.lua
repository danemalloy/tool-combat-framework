-- a list of all the valid movesets in game (for sanity checks)

return {
	["fists"] = {
		["combo"] = {
			["AnimationId1"] = "rbxassetid://123369282413158",
			["AnimationId2"] = "rbxassetid://83770284446889",
			["AnimationId3"] = "rbxassetid://114235300144018",
			
			["Cooldown"] = 0.4,
			["ClientCooldown"] = 0.1,
			["EndLag"] = 0.075,
			["Hitbox"] = Vector3.new(2,4,1),
			["Damage"] = 7,
		},
		["stomp"] = {
			["AnimationId"] = "rbxassetid://88979970119956",
		},
	},
	
	["block"] = {
		["start"] = {
			["AnimationId"] = "rbxassetid://136113470019342",
		},
		["finish"] = {
			["AnimationId"] = "rbxassetid://127327035983498",
		},
	}
}
