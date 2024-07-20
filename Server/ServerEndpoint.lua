--// API.lua

local ServerEndpoint = {}
local Endpoint = game.ReplicatedStorage:WaitForChild("Admin System Shared").ServerEndpoint
local RemoteEndpoint = game.ReplicatedStorage:WaitForChild("Admin System Shared").RemoteServerEndpoint
local Modules


function ServerEndpoint.CheckIn(Player)
	local RankID = Player:FindFirstChild("AdminRank")
	if RankID then
		RankID = RankID.Value
		return {Modules.Configuration.Ranks[RankID], RankID >= Modules.Configuration.CheckInRank}
	end
end

function ServerEndpoint.CommandBar(Player, Command)
	local PlayerData = Modules.PlayerHandler.PlayerData[Player.UserId]
	if PlayerData then
		Modules.CommandHandler.ParseCommand(PlayerData, Command)
	else
		warn("Invalid Player Data - CMD BAR FAIL.")
	end
end

function ServerEndpoint.RegisterEndpoint(Key, Function)
	ServerEndpoint[Key] = Function;
end


function ServerEndpoint.OnServerEvent(Player, Endpoint, ...)
	local Function = ServerEndpoint[Endpoint]
	return Function(Player, ...)
end

function ServerEndpoint.Init(LoadedModules)
	Modules = LoadedModules;
	Endpoint.OnServerInvoke = function(Player, Endpoint, ...)
		return ServerEndpoint.OnServerEvent(Player, Endpoint, ...)
	end
end

function ServerEndpoint.DeInit()
	RemoteEndpoint:FireAllClients("DeInit")
	Endpoint.OnServerInvoke = nil
end

return ServerEndpoint