local Modules
local CommandsModule = {}
CommandsModule.Commands = {
	
	{ -- TODO
		["Name"] = "commandinfo";
		["Aliases"] = {"cinfo", "cargs", "cmdinfo"};
		["Permissions"] = {"Any", {
			{"Guest"};
		}};
		["Arguments"] = {"Word"};
		["Function"] = function(Session)
			local CommandFound = Modules.CommandHandler.GetCommandFromName(Session.Execution.Arguments[1])
			if CommandFound then
				Modules.API.PromptGui(Session.Player.Client, "Statistics", {
					Title = "Command Info";
					Statistics = {
						"-> Name";
						CommandFound.Name;
						"-> Aliases:";
						table.concat(CommandFound.Aliases, ",");
						"-> Arguments:";
						table.concat(CommandFound.Arguments, ",");
						"-> Command Location:";
						CommandFound.CommandHolderName;
					};
				})
			else
				Modules.API.PromptGui(Session.Player.Client, "Alert", {
					Title = "Invalid Command!";
					Content = "Failed to find the specified command (for command info)."
				})
			end
		end;
	},
	
	{ -- TODO
		["Name"] = "version";
		["Aliases"] = {"v", "vinfo"};
		["Permissions"] = {"Any", {
			{"Guest"};
		}};
		["Arguments"] = {};
		["Function"] = function(Session)
			local Display = {}
			for VersionName, VersionData in pairs(Modules.BasicData.SystemVersion) do
				table.insert(Display, VersionName)
				for _, line in pairs(VersionData) do
					table.insert(Display, {
						Text = line;
						Font = Enum.Font.SourceSans;
					})
				end
			end
			
			Modules.API.PromptGui(Session.Player.Client, "Statistics", {
				Title = "Version Info";
				Statistics = Display;
			})
		end;
	},
	
	{ -- TODO
		["Name"] = "cmds";
		["Aliases"] = {"commands", "viewcommands", "help"};
		["Permissions"] = {"Any", {
			{"Guest"}
		}};
		["Arguments"] = {};
		["Function"] = function(Session)

			local CommandList = {}
			for CommandHolderName, CommandHolderContents in pairs(Modules.CommandHandler.CommandHolders) do
				table.insert(CommandList, "-> "..CommandHolderName..":")
				for _, CMD in pairs(CommandHolderContents) do
					table.insert(CommandList, {
						["Font"] = Enum.Font.SourceSans;
						["Text"] = CMD["Name"];
					})
				end
			end
			
			Modules.API.PromptGui(Session.Player.Client, "Statistics", {
				Title = "Command List";
				Statistics = CommandList;
			})
		end;
	},	
	
	{ -- TODO
		["Name"] = "serverstats";
		["Aliases"] = {"serverinfo", "playercount"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {};
		["Function"] = function(Session)
			local ServerInfo = {
				"Player Count: "..#game:GetService("Players"):GetPlayers();
				"Place ID: "..game.PlaceId;
				"Creator ID: "..game.CreatorId;
				"Private Server Owner: "..game.PrivateServerId;
				"Job ID: "..game.JobId;
			}
			
			Modules.API.PromptGui(Session.Player.Client, "Statistics", {
				Title = "Server Info";
				Statistics = ServerInfo;
			})
		end;
	},
	
	{ -- TODO
		["Name"] = "stafflogs";
		["Aliases"] = {"logs", "viewlogs"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {};
		["Function"] = function(Session)
			Modules.API.PromptGui(Session.Player.Client, "Statistics", {
				Title = "Staff Logs";
				Statistics = _G.StaffLogs;
			})
		end;
	},
	
	{ -- TODO
		["Name"] = "chatlogs";
		["Aliases"] = {"chats", "clogs"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {};
		["Function"] = function(Session)
			Modules.API.PromptGui(Session.Player.Client, "Statistics", {
				Title = "Chatlogs";
				Statistics = _G.ChatLogs;
			})
		end;
	},
	
	{ -- TODO
		["Name"] = "info";
		["Aliases"] = {"plrinfo"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"Player"};
		["Function"] = function(Session)
			local Player = Session.Execution.Arguments[1][1]
			local PlayerInfo = {
				"User ID: "..Player.UserId;
				"Display Name: "..Player.DisplayName;
				"Username: "..Player.Name;
				"Account Age: "..Player.AccountAge;
				"Admin Rank: "..Player:WaitForChild("AdminRank").Value;
			}
			
			if Player.Team and Player.Team.Name then
				table.insert(PlayerInfo, "Team: "..Player.Team.Name)
			end
			
			Modules.API.PromptGui(Session.Player.Client, "Statistics", {
				Title = Player.Name.."'s Info.";
				Statistics = PlayerInfo;
			})
		end;
	},
	
}

function CommandsModule.Init(LoadedModules)
	-- Setup Global Logging
	_G.ChatLogs = {}
	_G.StaffLogs = {}
	_G.Slock = false
	-- Load LoadedModules to local Module value.
	Modules = LoadedModules
	
	Modules.CommandHandler.RegisterCommandHolder("Utilities", CommandsModule.Commands)
end

return CommandsModule