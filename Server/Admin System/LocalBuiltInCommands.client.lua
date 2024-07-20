--// LocalBuiltInCommands

-- Main
local Shared = game:GetService("ReplicatedStorage"):WaitForChild("Admin System Shared")
local Endpoint = Shared.ClientCommand
local RemoteEndpoint = Shared.RemoteServerEndpoint
local ClientCommands = require(Shared.LocalCommands);


local Connection = Endpoint.OnClientEvent:Connect(function(Session)
	local Command = Session.Command.Name
	Command = ClientCommands[Command]
	
	local Success, Error = pcall(function()
		Command(Session)
	end)
	
	if not Success then
		warn(Error)
	end
end)

RemoteEndpoint.OnClientEvent:Connect(function(Command)
	script.Parent:Destroy()
end)