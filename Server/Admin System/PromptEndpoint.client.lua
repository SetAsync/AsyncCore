--// PromptEndpoint

-- Main
local Shared = game:GetService("ReplicatedStorage"):WaitForChild("Admin System Shared")
local Endpoint = Shared.GUIPrompt
local GUIElements = Shared.ScreenElements
local Hello = script.Parent.Hello
function Notify(Type, Payload)
	local NewElement = GUIElements:FindFirstChild(Type)
	if not NewElement then
		warn("Invalid Element")
		return
	end
	
	NewElement = NewElement:Clone()
	NewElement.Parent = script.Parent
	local NewElementModule = NewElement.Element
	Hello:Play()
	require(NewElementModule).Init(NewElement, Payload)
end

Endpoint.OnClientEvent:Connect(Notify)

-- Check In
local CheckIn = Shared.ServerEndpoint:InvokeServer("CheckIn")
if CheckIn then
	local Rank, Show = table.unpack(CheckIn)
	if Show then
		Notify("Notification", {
			Title = "Admin System";
			Content = "You've loaded in as rank '"..Rank[1].."'.";
		})
	end
else
	Notify("Alert", {
		Title = "Admin System";
		Content = "Server failed to respond to client 'check in.'";
	})
end

