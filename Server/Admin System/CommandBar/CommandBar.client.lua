--// CommandBar

local UserInputService = game:GetService("UserInputService")
local Endpoint = game.ReplicatedStorage:WaitForChild("Admin System Shared").ServerEndpoint

UserInputService.InputBegan:Connect(function(InputObject, GPE)
	if GPE then return end
	
	if InputObject.KeyCode == Enum.KeyCode.Semicolon then
		script.Parent.Visible = not script.Parent.Visible
	end
end)

script.Parent.CMD.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		Endpoint:InvokeServer("CommandBar", script.Parent.CMD.Text)
		script.Parent.Visible = false
	end
end)