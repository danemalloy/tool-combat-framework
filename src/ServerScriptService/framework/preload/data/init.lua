--!strict

--[[
	@data
	author: dane (dane1up)
	
	datastore cache for all player data, contains a few helper methods to actively save data throughout the game session
	
	methods:
		getPlayerProfile: (if available) returns the player profile
]]--

-- services
local Players = game:GetService("Players")
local Replicated = game:GetService("ReplicatedStorage")
local Server = game:GetService("ServerScriptService")

-- modules
local service = require(script.service)
local profileTemplate = require(Replicated.framework.libs.playerDataTemplate)
local network = require(Replicated.framework.modules.network)
local character = require(Server.framework.modules.character)

-- profile store
local PROFILE_STORE = service.GetProfileStore("testing_v1.0.0", profileTemplate)

-- methods
local module = {}
local cache = {}

local loadLeaderstats = function(player: Player, data: profileTemplate.PlayerDataTemplate)
	if (not cache[player]["Data"]) then return end
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player
	
	local kills = Instance.new("NumberValue")
	kills.Name = "Kills"
	kills.Value = data["kills"]
	kills.Parent = leaderstats
	
	local aura = Instance.new("NumberValue")
	aura.Name = "Aura"
	aura.Value = data["aura"]
	aura.Parent = leaderstats
	
	local moveset = Instance.new("StringValue")
	moveset.Name = "Moveset"
	moveset.Value = data["activeMoveset"]
	moveset.Parent = leaderstats
end

local playerAdded = function(player: Player)
	local profile = PROFILE_STORE:LoadProfileAsync("player_"..player.UserId, "ForceLoad")
	
	if (not profile) then
		player:Kick("[ERROR] could not load data profile")
		return
	end

	if profile["Data"]["Banned"] then
		player:Kick("[SERVER LOG] you are banned from fight in a street")
	end

	profile:AddUserId(player.UserId)
	profile:Reconcile()
	profile:ListenToRelease(function()
		cache[player] = nil
		player:Kick("[SERVER LOG] data profile released")
		return
	end)

	if (not player:IsDescendantOf(Players)) then
		profile:Release()
		return
	end

	cache[player] = profile

	loadLeaderstats(player, profile["Data"])
	character.characterAdded(player, profile["Data"])
	
	network.sendClient(player, "loaded")
end

local playerRemoving = function(player: Player)
	if (not cache[player]) then return end
	cache[player]:Release()
end

module.getPlayerProfile = function(player: Player)
	if cache[player] then
		return cache[player]
	end
	return nil
end

for _, player: Player in Players:GetPlayers() do
	playerAdded(player)
end

-- connections
Players.PlayerAdded:Connect(playerAdded)
Players.PlayerRemoving:Connect(playerRemoving)

network.add("getPlayerProfile", function(player: Player)
	return module.getPlayerProfile(player)
end)

module.loaded = true

return module
