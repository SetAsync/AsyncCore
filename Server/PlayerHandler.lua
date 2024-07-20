-- PLAYERHANDLER.LUA | SETASYNC | 2023

local PlayerHandler = {}
local Players = game:GetService("Players")
local Client = script.Parent["Admin System"]
local DataStoreService = game:GetService("DataStoreService")
local Modules, QuickPerms, BanStore
PlayerHandler.RBXScriptConnections = {}
PlayerHandler.PlayerData = {}

function PlayerHandler.PlayerAdded(Player)
	-- Get Rank.
	local HighestRank
	for RankID, RankData in pairs(Modules.Configuration.Ranks) do
		local RankName, PermissionCheckType, PermissionChecks = table.unpack(RankData)
		local Applicable = QuickPerms(Player, PermissionCheckType, PermissionChecks)
		if Applicable then
			if (not HighestRank) or (RankID > HighestRank) then
				HighestRank = RankID
			end
		end
	end
	if not HighestRank then
		Player:Kick("ADMIN SYSTEM - You don't fit into any ranks.")
	end
	
	if _G.Slock then
		if HighestRank < _G.Slock then
			Player:Kick("Server Locked - Your rank is too low.")
		end
	end
	
	-- Load Ban.
	local LoadedData
	local Success, Error = pcall(function()
		LoadedData = BanStore:GetAsync(tostring(Player.UserId))
	end)
	LoadedData = LoadedData or false
	if not Success then
		warn("ADMIN SYSTEM - LOAD BANSTORE -"..Error)
	end
	if LoadedData then
		if type(LoadedData) == "number" then
			if os.time() < LoadedData then
				Player:Kick("You are currently banned from this game.")
			end
		else
			Player:Kick("You are permanently banned from this game.")
		end

	end
	
	local PlayerLocalData = {Player = Player, HighestRank = HighestRank, SaveData = Success, LoadedAt = os.time()};
	PlayerHandler.PlayerData[Player.UserId] = PlayerLocalData
	
	local RankStore = Instance.new("IntValue", Player)
	RankStore.Name = "AdminRank"
	RankStore.Value = HighestRank
	
	-- Clone client.
	local NewClient = Client:Clone()
	NewClient.Parent = Player.PlayerGui
	
	-- Handle Messages.
	table.insert(PlayerHandler.RBXScriptConnections, Player.Chatted:Connect(function(Message)
		if string.lower(Message:sub(1,#Modules.Configuration.CommandPrefix)) == Modules.Configuration.CommandPrefix then
			local RawCommand = Message:sub(#Modules.Configuration.CommandPrefix+1)
			Modules.CommandHandler.ParseCommand(PlayerLocalData, RawCommand)
		end
		if _G.ChatLogs then
			if _G.ChatLogs[Modules.Configuration.LogLimit] then
				table.remove(_G.ChatLogs, 1)
			end
			Message = game:GetService("Chat"):FilterStringForBroadcast(Message, Player)
			table.insert(_G.ChatLogs, Player.Name..": "..Message)
		end
	end))
	
	-- Handle Jails
	table.insert(PlayerHandler.RBXScriptConnections, Player.CharacterAdded:Connect(function()
		local Character = Player.Character
		local Jail = Player.UserId.."'s Jail"
		Jail = workspace:FindFirstChild(Jail)
		
		if Jail then
			wait(1)
			Character:MoveTo(Jail.Floor.Position)
		end
	end))
end

function PlayerHandler.PlayerRemoving(Player)	
	PlayerHandler.PlayerData[Player.UserId] = nil;
end

function PlayerHandler.GetPlayerData(Player)
	return PlayerHandler.PlayerData[Player.UserId];
end

function PlayerHandler.Init(LoadedModules)
	Modules = LoadedModules
	QuickPerms = Modules.QuickPerms.Init(Modules.Configuration.CustomPermissionsChecks)
	BanStore = DataStoreService:GetDataStore(Modules.Configuration.BanDatastore)
	-- Setup "PlayerAdded"
	for _, v in ipairs(Players:GetPlayers()) do
		coroutine.wrap(PlayerHandler.PlayerAdded)(v)
	end
	table.insert(PlayerHandler.RBXScriptConnections, Players.PlayerAdded:Connect(PlayerHandler.PlayerAdded))
	table.insert(PlayerHandler.RBXScriptConnections, Players.PlayerRemoving:Connect(PlayerHandler.PlayerRemoving))
end

function PlayerHandler.DeInit()
	for _, v in ipairs(PlayerHandler.RBXScriptConnections) do
		v:Disconnect()
	end
	
	for _, v in ipairs(Players:GetPlayers()) do
		if v:FindFirstChild("AdminRank") then
			v.AdminRank:Destroy()
		end
	end
end

return PlayerHandler