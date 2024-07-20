local Modules
local CommandsModule = {}
CommandsModule.Commands = {
	
	{ -- TODO
		["Name"] = "slock";
		["Aliases"] = {"serverlock", "lockserver"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {};
		["Function"] = function(Session)
			_G.Slock = Session.Player.Rank
			Modules.API.PromptGui(Session.Player.Client, "Alert", {
				Title = "Success";
				Content = "No users below your rank are able to join."
			})
		end;
	},
	
	{ -- TODO
		["Name"] = "unslock";
		["Aliases"] = {"unserverlock", "unlockserver"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {};
		["Function"] = function(Session)
			_G.Slock = nil
			Modules.API.PromptGui(Session.Player.Client, "Alert", {
				Title = "Success";
				Content = "The SLOCK has been removed."
			})
		end;
	},
	
	{ -- TODO
		["Name"] = "team";
		["Aliases"] = {"setteam", "assign"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"Player", "Phrase"};
		["Function"] = function(Session)
			-- Get Team.
			local Team = Session.Execution.Arguments[2]
			Team = game:GetService("Teams"):FindFirstChild(Team)
			
			if not Team then
				-- Attempt to find the team.
				Team = Modules.API.DumbString(game:GetService("Teams"):GetTeams(), Session.Execution.Arguments[2])
			end
			
			if Team then
				for _,v in ipairs(Session.Execution.Arguments[1]) do
					v.Team = Team
				end
			else
				Modules.API.PromptGui(Session.Player.Client, "Alert", {
					Title = "Invalid Team";
					Content = "Failed to find the specified team."
				})
			end
		end;
	},
	
	{
		["Name"] = "removetools";
		["Aliases"] = {"cleartools"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"Player"};
		["Function"] = function(Session)
			for _, v in ipairs(Session.Execution.Arguments[1]) do
				if v.Character then
					local HeldTool = v.Character:FindFirstChildOfClass("Tool")
					HeldTool:Destroy()
				end

				v.Backpack:ClearAllChildren()

			end
		end;
	},

	{
		["Name"] = "givetool";
		["Aliases"] = {};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"Player", "Phrase"};
		["Function"] = function(Session)
			--> Get tool.
			local Tool = Modules.Tree.FindFirstDescendant(game.ServerStorage, {
				{"Property", "ClassName", "Tool"};
				{"Property", "Name", Session.Execution.Arguments[2]}
			})
			if not Tool then
				Modules.API.PromptGui(Session.Player.Client, "Alert", {
					Title = "Invalid Tool";
					Content = "Failed to find the tool in ServerStorage!";
				})
				return
			end

			for _, v in ipairs(Session.Execution.Arguments[1]) do
				local NT = Tool:Clone()
				NT.Parent = v.Backpack
			end

		end;
	},
	
	{
		["Name"] = "time";
		["Aliases"] = {"settime", "timeofday", "hour"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"Number"};
		["Function"] = function(Session)
			game:GetService("Lighting").TimeOfDay = Session.Execution.Arguments[1]
		end;
	},
	
	{ -- TODO
		["Name"] = "setstats";
		["Aliases"] = {"change", "set", "leaderstats", "leaderstat", "stats"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"Player", "Word", "FilterPhrase"};
		["Function"] = function(Session)
			for _,v in ipairs(Session.Execution.Arguments[1]) do
				local Stat
				for _,vChild in ipairs(v.leaderstats:GetChildren()) do
					if vChild:IsA("StringValue") or vChild:IsA("NumberValue") then
						if vChild.Name:lower() == Session.Execution.Arguments[2]:lower() then
							Stat = vChild
						end
					end
				end
				if Stat then
					print(Stat)
					if type(Stat.Value) == "string" then
						Stat.Value = Session.Execution.Arguments[3]
					else
						Stat.Value = tonumber(Session.Execution.Arguments[3])
					end
				else
					Modules.API.PromptGui(Session.Player.Client, "Alert", {
						Title = "Invalid Stat";
						Content = "Failed to find the statistic.";
					})
				end
			end
		end;
	},
	
	{ -- TODO
		["Name"] = "message";
		["Aliases"] = {"notification", "notify", "w", "m"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"Player", "FilterPhrase"};
		["Function"] = function(Session)
			for _, v in ipairs(Session.Execution.Arguments[1]) do
				Modules.API.PromptGui(v, "Alert", {
					Title = "Message";
					Content = Session.Execution.Arguments[2];
					ButtonText = "Close";
				})
			end
		end;
	},
	
	{ -- TODO
		["Name"] = "announce";
		["Aliases"] = {};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"FilterPhrase"};
		["Function"] = function(Session)
			Modules.API.PromptGui("All", "Alert", {
					Title = "Message";
					Content = Session.Execution.Arguments[2];
					ButtonText = "Close";
			})
		end;
	},
	
	{ -- TODO
		["Name"] = "shutdown";
		["Aliases"] = {};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {};
		["Function"] = function(Session)
			for _, v in ipairs(game:GetService("Players"):GetPlayers()) do
				v:Kick("This server has been shutdown by an admin.")
			end
		end;
	},
	
	{ -- TODO
		["Name"] = "em";
		["Aliases"] = {};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"FilterPhrase"};
		["Function"] = function(Session)
			for _, v in ipairs(game:GetService("Players"):GetPlayers()) do
				Modules.API.PromptGui(v, "Alert", {
					Title = "Emergency Message";
					Content = Session.Execution.Arguments[1];
					ButtonText = "Close";
				})
			end
		end;
	},
	
	{ -- TODO
		["Name"] = "handto";
		["Aliases"] = {};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"SinglePlayer"};
		["Function"] = function(Session)
			local Tool = Session.Player.Client.Character:FindFirstChildOfClass("Tool")
			if Tool then
				Tool.Parent = Session.Execution.Arguments[1][1].Backpack
			else
				Modules.API.PromptGui(Session.Player.Client, "Alert", {
					Title = "Error!";
					Content = "Please hold a tool first."
				})
			end
		end;
	},
	
	{ -- TODO
		["Name"] = "tools";
		["Aliases"] = {"viewtools", "seetools"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"Player"};
		["Function"] = function(Session)
			local Player = Session.Execution.Arguments[1][1]
			local Tools = {}
			
			for _,v in ipairs(Player.Backpack:GetChildren()) do
				if v:IsA("Tool") then
					table.insert(Tools, v.Name)
				end
			end
			
			if Player.Character and Player.Character:FindFirstChildOfClass("Tool") then
				local HeldTool = Player.Character:FindFirstChildOfClass("Tool")
				table.insert(Tools, HeldTool.Name)
			end
			
			Modules.API.PromptGui(Session.Player.Client, "Statistics", {
				Title = Player.Name.."'s Tools";
				Statistics = Tools;
			})
		end;
	},
	
	{ -- TODO
		["Name"] = "countdown";
		["Aliases"] = {"timer"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"Player", "Number"};
		["Function"] = function(Session)
			local Time = os.time() + Session.Execution.Arguments[2]
			for _,v in ipairs(Session.Execution.Arguments[1]) do
				Modules.API.PromptGui(Session.Player.Client, "Countdown", Time)
			end
		end;
	},
	
	{ -- TODO
		["Name"] = "serverjoinid";
		["Aliases"] = {"joinserver"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"Phrase"};
		["Function"] = function(Session)
			local TPs = game:GetService("TeleportService")
			local Success, Error = pcall(function()
				TPs:TeleportToPlaceInstance(game.PlaceId, Session.Execution.Arguments[1], Session.Player.Client)	
			end)
			if not Success then
				Modules.API.PromptGui(Session.Player.Client, "Notification", {
					Title = "Error!";
					Content = "Teleport failed.";
				})
				warn(Error)
			end
		end;
	},
	
	{
		["Name"] = "to";
		["Aliases"] = {"tpto", "goto", "find"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"SinglePlayer"};
		["Function"] = function(Session)
			local Victim = Session.Player.Client.Character
			local Destination = Session.Execution.Arguments[1][1].Character
			
			print(Victim, Destination)
			if Victim and Destination then
				Victim:MoveTo(Destination.PrimaryPart.Position)
			else
				Modules.API.PromptGui(Session.Player.Client, "Notification", {
						Title = "Error!";
						Content = "No character exists.";
				})
			end
		end;
	},
	
	{
		["Name"] = "bring";
		["Aliases"] = {"fetch", "tphere"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"SinglePlayer"};
		["Function"] = function(Session)
			local Destination = Session.Player.Client.Character
			local Victim = Session.Execution.Arguments[1][1].Character

			if Victim and Destination then
				Victim:MoveTo(Destination.PrimaryPart.Position)
			else
				Modules.API.PromptGui(Session.Player.Client, "Notification", {
					Title = "Error!";
					Content = "No character exists.";
				})
			end
		end;
	},
	
	{
		["Name"] = "tp";
		["Aliases"] = {"teleport", "tardis"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"Player", "SinglePlayer"};
		["Function"] = function(Session)
			local Destination = Session.Execution.Arguments[2][1].Character
			for _, Victim in ipairs(Session.Execution.Arguments[1]) do
				local Victim = Victim.Character

				if Victim and Destination then
					Victim:MoveTo(Destination.PrimaryPart.Position)
				else
					Modules.API.PromptGui(Session.Player.Client, "Notification", {
						Title = "Error!";
						Content = "No character exists.";
					})
				end
			end

		end;
	}
	
}

function CommandsModule.RegisterCommand(Command)
	table.insert(CommandsModule.Commands, Command)
end

function CommandsModule.Init(LoadedModules)
	-- Load LoadedModules to local Module value.
	Modules = LoadedModules
	
	Modules.CommandHandler.RegisterCommandHolder("Tools", CommandsModule.Commands)
end

return CommandsModule