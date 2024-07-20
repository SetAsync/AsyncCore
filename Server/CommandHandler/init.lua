local CommandHandler = {}
local Modules, QuickPerms
local Players = game:GetService("Players")
CommandHandler.CommandHolders = {}
CommandHandler.RegisterCommands = true

-- Registers a new command holder with the specified command contents.
CommandHandler.BlacklistedHolders = {}

function CommandHandler.RegisterCommandHolder(CommandHolderName, CommandContents)
	if table.find(CommandHandler.BlacklistedHolders, CommandHolderName) then
		return
	end
	
	-- Validate all new commands.
	local NewCommandTable = {}
	
	for proposedCommandIndex, proposedCommand in ipairs(CommandContents) do
		local Found = CommandHandler.GetCommandFromName(proposedCommand.Name)
		if Found then
			warn("Failed to RegisterCommandHolder '"..CommandHolderName.."'' with dublicate command name '"..proposedCommand.Name.."' from '"..Found.CommandHolderName.."'.") 
			return false
		end
		
		for _, Alias in pairs(proposedCommand.Aliases) do
			local Found = CommandHandler.GetCommandFromName(Alias)
			if Found then
				warn("Failed to RegisterCommandHolder '"..CommandHolderName.."'' with dublicate command alias '"..proposedCommand.Name.."' from '"..Found.CommandHolderName.."'.") 
				return false
			end
		end
		
		-- Overwrite Command Properties
		
		local AcceptingCommand = CommandHandler.RegisterCommands
		
		if Modules.Configuration.OverwriteCommands[proposedCommand.Name] then
			for settingName, settingValue in pairs(Modules.Configuration.OverwriteCommands[proposedCommand.Name]) do
				proposedCommand[settingName] = settingValue
				
				if settingName == "ForceRegister" then
					AcceptingCommand = settingValue;
				end
			end
		end

			
		if AcceptingCommand then
			table.insert(NewCommandTable, proposedCommand)
		end
	end
	
	-- Set
	CommandHandler.CommandHolders[CommandHolderName] = NewCommandTable;
end

function CommandHandler.BlacklistCommands(CommandHolderName)
	table.insert(CommandHandler.BlacklistedHolders, CommandHolderName)
	if CommandHandler.CommandHolders[CommandHolderName] then
		CommandHandler.CommandHolders[CommandHolderName] = nil
	end
end

-- Returns a "Command" table provided a command name or alias.
function CommandHandler.GetCommandFromName(CommandName)
	CommandName = CommandName:lower()
	
	-- Strip command of prefix, if one exists.
	-- (For cases with multirun commands.)
	local Prefix = Modules.Configuration.CommandPrefix:lower()
	local PrefixedCommand = string.sub(CommandName, 1, #Prefix)
	
	if Prefix == PrefixedCommand then
		CommandName = string.sub(CommandName, #Prefix+1, #CommandName)
	end
	
	
	local ResultCommand
	for CommandHolderName, CommandHolder in pairs(CommandHandler.CommandHolders) do
		for _, Command in ipairs(CommandHolder) do
			for i,v in pairs(Command.Aliases) do
				Command.Aliases[i] = v:lower()				
			end
			if table.find(Command.Aliases, CommandName) or (Command.Name:lower() == CommandName) then
				Command["CommandHolderName"] = CommandHolderName;
				return Command
			end
		end
	end
end

CommandHandler.ParseArguments = {}

function CommandHandler.ParseArguments.FilterWord(RawArguments, Index, Player)
	local Word = RawArguments[Index]
	Word = game:GetService("Chat"):FilterStringForBroadcast(Word, Player)
	return Word
end

function CommandHandler.ParseArguments.Word(RawArguments, Index)
	return RawArguments[Index]
end

function CommandHandler.ParseArguments.Player(RawArguments, Index, Player)
	local PlayerName = RawArguments[Index]
	PlayerName = PlayerName:lower()
	
	local RET
	
	if PlayerName == "all" then
		RET = Players:GetPlayers()
	elseif PlayerName == "others" then
		local Others = Players:GetPlayers()
		table.remove(Others, table.find(Others, Player))
		RET = Others
	elseif PlayerName == "random" then
		local All = Players:GetPlayers()
		RET = {All[math.random(1,#All)]}
	elseif PlayerName == "me" then
		RET = {Player}
	elseif string.sub(PlayerName, 1, 1) == "%" then
		local Team = Modules.API.DumbString(game:GetService("Teams"):GetTeams(), string.sub(PlayerName, 2, #PlayerName))
		if Team then
			RET = Team:GetPlayers()
		else
			return false, "Invalid Team! (%)"
		end
	else
		-- Player Name
		for _,v in ipairs(game.Players:GetPlayers()) do
			if v.Name:lower():sub(1,#PlayerName) == PlayerName then
				return {v} -- RET exception cus yk
			end
		end
	end
	
	if RET then
		if #RET ~= 0 then
			return RET
		else
			return false, "No players matched argument."
		end
	end
	return false, "Invalid Player Argument"
end

function CommandHandler.ParseArguments.SinglePlayer(RawArguments, Index, Player)
	local Success, Error = CommandHandler.ParseArguments.Player(RawArguments, Index, Player)
	if Success then
		if #Success == 1 then
			return Success
		else
			return false, "This argument is limited to ONE victim only."
		end
	else
		return Success, Error
	end
end

function CommandHandler.ParseArguments.Number(RawArguments, Index)
	local Number = RawArguments[Index]
	Number = tonumber(Number)
	if Number then
		return Number
	else
		return false, "Invalid Number" -- Needed inefficency as evaluation for end is (ArgA * ArgB).
	end
end

function CommandHandler.ParseArguments.Phrase(RawArguments, Index)
	local NewTable = {}
	for i=Index,#RawArguments do
		local v = RawArguments[i]
		table.insert(NewTable,v)
	end
	
	NewTable = table.concat(NewTable, " ")
	return NewTable
end

function CommandHandler.ParseArguments.FilterPhrase(RawArguments, Index, Player)
	local Phrase = CommandHandler.ParseArguments.Phrase(RawArguments, Index)
	return game:GetService("Chat"):FilterStringForBroadcast(Phrase, Player)
end

-- Returns a formatted arguments table provided the commandarguments preset and the raw arguments.
function CommandHandler.AssertArguments(CommandArguments, RawArguments, Player)
	-- Assert basic length.
	if table.find(CommandArguments, "Phrase") or table.find(CommandArguments, "FilterPhrase") then
		if #RawArguments < #CommandArguments then
			return false, "Missing Arguments!"
		end
	else
		if #RawArguments ~= #CommandArguments then
			return false, "Invalid Arguments!"
		end
	end
	
	-- Convert / Parse.
	local FinishedArguments = {}
	for i, v in ipairs(CommandArguments) do
		local ArgumentEncoder = CommandHandler.ParseArguments[v]
		local EncodedArgument, Error = ArgumentEncoder(RawArguments, i, Player)
		if EncodedArgument then
			-- Success
			table.insert(FinishedArguments, EncodedArgument)
			if EncodedArgument and Error then
				-- Success, and end.
				return FinishedArguments
			end
		else
			return false, Error
		end
	end
	return FinishedArguments
end


function CommandHandler.TriggerCommand(Owner, RawCommand, Command, Arguments, NoLog)
	 
	if Command then
		--> Player Authorised?
		local Authorised = QuickPerms(Owner.Player, Command.Permissions[1], Command.Permissions[2])
		if Authorised then
			-- Assert Arguments.
			local EncodedArguments, Error = CommandHandler.AssertArguments(Command.Arguments, Arguments, Owner.Player)
			if EncodedArguments then
				local Execution = {
					["Player"] = {
						["Client"] = Owner.Player;
						["Rank"] = Owner.HighestRank;
						["SaveData"] = Owner.SaveData;
						["LoadedAt"] = Owner.LoadedAt;
					};
					["Command"] = Command;
					["Execution"] = {
						["Arguments"] = EncodedArguments;
						["RawArguments"] = Arguments;
						["RawCommand"] = RawCommand;
					}
				}

				-- Execute Command.
				local Success, Error = pcall(function()
					Command.Function(Execution)
				end)
				if Success then
					-- LOG SUCCESS
					-- ENTRY | STRING
					if not NoLog then
						local VictimPlayer = "."
						for _, v in ipairs(EncodedArguments) do
							if type(v) == "table" then
								VictimPlayer = " on "..v[1].Name.."."
							end
						end

						if _G.StaffLogs then
							if _G.StaffLogs[Modules.Configuration.LogLimit] then
								table.remove(_G.StaffLogs, 1)
							end
							local Entry = Owner.Player.Name.." ran "..Command.Name..VictimPlayer
							table.insert(_G.StaffLogs, Entry)
						end	
					end
				
					print("Executed Command.")	
				else
					Modules.API.PromptGui(Owner.Player, "Alert", {
						Title = "Execution Error!";
						Content = Error;
					})
				end
			else
				Modules.API.PromptGui(Owner.Player, "Alert", {
					Title = "Failed to execute.";
					Content = Error;
				})
			end
		else
			Modules.API.PromptGui(Owner.Player, "Notification", {
				Title = "Unauthorised!";
				Content = "You do not have access to this command!";
			})
		end
	else
		Modules.API.PromptGui(Owner.Player, "Notification", {
			Title = "Invalid Command";
			Content = "Failed to find the provided command!"
		})
	end
end

-- Asserts and executes a command from a spoken raw command.
function CommandHandler.ParseCommand(Owner, RawCommand)
	-- RECURSION TO ALLOW MULTIPLE COMMANDS
	local Commands = RawCommand:split(Modules.Configuration.CommandSplit)
	if #Commands ~= 1 then
		for _,v in ipairs(Commands) do
			CommandHandler.ParseCommand(Owner, v)
		end
		return
	end
	
	-- Get command name.
	local Arguments = RawCommand:split(" ")
	local CommandName = Arguments[1]:lower()
	table.remove(Arguments, 1)
	
	local Command = CommandHandler.GetCommandFromName(CommandName)
	if Command then
		CommandHandler.TriggerCommand(Owner, RawCommand, Command, Arguments)
	else
		Modules.API.PromptGui(Owner.Player, "Notification", {
			Title = "Invalid Command";
			Content = "Failed to find the provided command!"
		})
	end
end

function CommandHandler.PreInit(LoadedModules)
	Modules = LoadedModules
	QuickPerms = Modules.QuickPerms.Init(Modules.Configuration.CustomPermissionsChecks)
end

return CommandHandler