--!strict

--[[
	@handler
	author: dane (dane1up)
	
	client sided tool handler
]]--

-- services
local Players = game:GetService("Players")
local Replicated = game:GetService("ReplicatedStorage")
local Context = game:GetService("ContextActionService")

-- yield
repeat
	task.wait()
until Players.LocalPlayer.Character

-- modules
local network = require(Replicated.framework.modules.network)
local lock = require(Players.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("framework"):WaitForChild("modules"):WaitForChild("lock"))
lock:Enable()

local tool = script.Parent.Parent

-- local methods
local handleAction = function(name: string, state: Enum.UserInputState)
	if (name == "M1") and (state == Enum.UserInputState.Begin) then
		network.sendServer(
			"handleAction",
			{
				["Move"] = "fists",
				["Set"] = "combo",
			}
		)
	elseif (name == "Stomp") and (state == Enum.UserInputState.Begin) then
		network.sendServer("handleAction",
			{
				["Move"] = "fists",
				["Set"] = "stomp",
			}
		)
	elseif (name == "Block") and (state == Enum.UserInputState.Begin) then
		network.sendServer(
			"handleAction",
			{
				["Move"] = "block",
				["Set"] = "start",
			}
		)
	end
end

local equipped = function()
	network.sendServer("equip")
	Context:BindAction("M1", handleAction, false, Enum.UserInputType.MouseButton1, Enum.UserInputType.Touch, Enum.KeyCode.ButtonR2) -- all platforms friendly
	Context:BindAction("Stomp", handleAction, true, Enum.KeyCode.E, Enum.KeyCode.ButtonX) -- all platforms friendly
	Context:BindAction("Block", handleAction, true, Enum.KeyCode.F, Enum.KeyCode.ButtonL2) -- all platforms friendly
	lock:ToggleShiftLock(true)
end

local unequipped = function()
	network.sendServer("unequip")
	Context:UnbindAction("M1")
	Context:UnbindAction("Stomp")
	Context:UnbindAction("Block")
	lock:ToggleShiftLock(false)
end

-- connections
tool.Equipped:Connect(equipped)
tool.Unequipped:Connect(unequipped)
