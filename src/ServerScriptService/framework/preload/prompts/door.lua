--!strict

-- services
local Tween = game:GetService("TweenService")

return function(prompt: ProximityPrompt)
	if (prompt:GetAttribute("DoorType") == "Left") then
		local door = prompt.Parent :: UnionOperation
		local model = door.Parent :: Model
		local hinge = model:FindFirstChild("Hinge") :: BasePart

		local info = TweenInfo.new(1)
		local TWEEN_OPEN = Tween:Create(hinge, info, {CFrame = hinge.CFrame * CFrame.Angles(0, math.rad(90), 0)})
		local TWEEN_CLOSE = Tween:Create(hinge, info, {CFrame = hinge.CFrame * CFrame.Angles(0, 0, 0)})
		
		prompt.Triggered:Connect(function(player: Player)
			if prompt.ActionText == "Close" then
				TWEEN_CLOSE:Play()
				local sound = door:FindFirstChild("CloseSound") :: Sound
				sound:Play()
				prompt.Enabled = false	
				wait(4)
				prompt.Enabled = true
				prompt.ActionText = "Open"
			else
				TWEEN_OPEN:Play()		
				local sound = door:FindFirstChild("OpenSound") :: Sound
				sound:Play()
				prompt.Enabled = false	
				wait(4)
				prompt.Enabled = true
				prompt.ActionText = "Close"
			end
		end)
	elseif (prompt:GetAttribute("DoorType") == "Right") then
		local door = prompt.Parent :: UnionOperation
		local model = door.Parent :: Model
		local hinge = model:FindFirstChild("Hinge") :: BasePart

		local info = TweenInfo.new(1)
		local TWEEN_OPEN = Tween:Create(hinge, info, {CFrame = hinge.CFrame * CFrame.Angles(0, math.rad(-90), 0)})
		local TWEEN_CLOSE = Tween:Create(hinge, info, {CFrame = hinge.CFrame * CFrame.Angles(0, 0, 0)})
		
		prompt.Triggered:Connect(function(player: Player)
			if prompt.ActionText == "Close" then
				TWEEN_CLOSE:Play()
				local sound = door:FindFirstChild("CloseSound") :: Sound
				sound:Play()
				prompt.Enabled = false	
				wait(4)
				prompt.Enabled = true
				prompt.ActionText = "Open"
			else
				TWEEN_OPEN:Play()		
				local sound = door:FindFirstChild("OpenSound") :: Sound
				sound:Play()
				prompt.Enabled = false	
				wait(4)
				prompt.Enabled = true
				prompt.ActionText = "Close"
			end
		end)
	end
end
