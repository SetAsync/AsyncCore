local Modules
local CommandsModule = {}
CommandsModule.Commands = {
	
	{ -- Kick | DONE
		["Name"] = "kick";
		["Aliases"] = {"disconnect","remove"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"Player", "FilterPhrase"};
		["Function"] = function(Session)
			
			for _, Victim in ipairs(Session.Execution.Arguments[1]) do
				local Granted = Modules.API.UserMayHarm(Session.Player.Client, Victim)
				if Granted then
					Victim:Kick(Session.Execution.Arguments[2])
				else
					Modules.API.PromptGui(Session.Player.Client, "Alert", {
						Title = "Unauthorised";
						Content = "Your rank is lower then this player's rank!"
					})
				end
			end

		end;
	},
	
	{ -- BAN | TODO
		["Name"] = "ban";
		["Aliases"] = {"tempban"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"SinglePlayer", "Number", "FilterPhrase"};
		["Function"] = function(Session)
			local Victim = Session.Execution.Arguments[1][1]
			
			-- Work out ending UNIX.
			local EndDate = Session.Execution.Arguments[2]
			EndDate = EndDate * 24 * 60 * 60
			EndDate = os.time() + EndDate
			
			local KickReason = Session.Execution.Arguments[3]
			
			local ValidBan = Modules.API.UserMayHarm(Session.Player.Client, Victim)
			if not ValidBan then
				Modules.API.PromptGui(Session.Player.Client, "Alert", {
					Title = "Unauthorised!";
					Content = "Your rank is not above the victim!"
				})
				return
			end
			
			-- BAN.
			local DS = game:GetService("DataStoreService")
			local BanStore = DS:GetDataStore(Modules.Configuration.BanDatastore)
			
			local Success, Error = pcall(function()
				BanStore:SetAsync(tostring(Victim.UserId), EndDate)
			end)
			
			if Success then
				Modules.API.PromptGui(Session.Player.Client, "Alert", {
					Title = "Success.";
					Content = "The user was banned."
				})
				Victim:Kick("You have been banned for "..Session.Execution.Arguments[2].." days.\nREASON: "..Session.Execution.Arguments[3])

			end
		end;
	},
	
	{ -- BAN | TODO
		["Name"] = "banid";
		["Aliases"] = {"tempban", "banfromid", "banid"};
		["Permissions"] = {"Any", {
			{"Rank", 3};
		}};
		["Arguments"] = {"Number", "Number"};
		["Function"] = function(Session)
			local Victim = Session.Execution.Arguments[1]

			-- Work out ending UNIX.
			local EndDate = Session.Execution.Arguments[2]
			EndDate = EndDate * 24 * 60 * 60
			EndDate = os.time() + EndDate
			-- BAN.
			local DS = game:GetService("DataStoreService")
			local BanStore = DS:GetDataStore(Modules.Configuration.BanDatastore)

			local Success, Error = pcall(function()
				BanStore:SetAsync(tostring(Victim), EndDate)
			end)

			if Success then
				Modules.API.PromptGui(Session.Player.Client, "Alert", {
					Title = "Success.";
					Content = "The user was banned."
				})
			end
		end;
	},
	
	{ -- PBAN | TODO
		["Name"] = "pban";
		["Aliases"] = {"permban"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"SinglePlayer", "FilterPhrase"};
		["Function"] = function(Session)
			local Victim = Session.Execution.Arguments[1][1]

			-- Work out ending UNIX. | PERM == TRUE
			local EndDate = true

			local KickReason = Session.Execution.Arguments[2]

			local ValidBan = Modules.API.UserMayHarm(Session.Player.Client, Victim)
			if not ValidBan then
				Modules.API.PromptGui(Session.Player.Client, "Alert", {
					Title = "Unauthorised!";
					Content = "Your rank is not above the victim!"
				})
				return
			end

			-- BAN.
			local DS = game:GetService("DataStoreService")
			local BanStore = DS:GetDataStore(Modules.Configuration.BanDatastore)

			local Success, Error = pcall(function()
				BanStore:SetAsync(tostring(Victim.UserId), EndDate)
			end)

			if Success then
				Modules.API.PromptGui(Session.Player.Client, "Alert", {
					Title = "Success.";
					Content = "The user was banned."
				})
				Victim:Kick("You have been banned.\nREASON: "..Session.Execution.Arguments[3])

			end
		end;
	},
	
	{ -- BAN | TODO
		["Name"] = "permbanid";
		["Aliases"] = {"pbanid", "permbanuserid", "pbanfromid", "permbanfromid"};
		["Permissions"] = {"Any", {
			{"Rank", 3};
		}};
		["Arguments"] = {"Number"};
		["Function"] = function(Session)
			local Victim = Session.Execution.Arguments[1]

			-- Work out ending UNIX.
			-- BAN.
			local DS = game:GetService("DataStoreService")
			local BanStore = DS:GetDataStore(Modules.Configuration.BanDatastore)

			local Success, Error = pcall(function()
				BanStore:SetAsync(tostring(Victim), true)
			end)

			if Success then
				Modules.API.PromptGui(Session.Player.Client, "Alert", {
					Title = "Success.";
					Content = "The user was banned."
				})
			end
		end;
	},
	
	{ -- TODO
		["Name"] = "unban";
		["Aliases"] = {"delban", "removeban"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"Number"};
		["Function"] = function(Session)
			local DS = game:GetService("DataStoreService")
			local BanStore = DS:GetDataStore(Modules.Configuration.BanDatastore)

			
			local Success, Error = pcall(function()
				BanStore:SetAsync(tostring(Session.Execution.Arguments[1]), false)
			end)
			
			if Success then
				Modules.API.PromptGui(Session.Player.Client, "Alert", {
					Title = "Unbanned.";
					Content = "Cleared any bans for the specified User ID."
				})
			end
		end;
	},
	
	{ -- TODO
		["Name"] = "mute";
		["Aliases"] = {"nochat", "timeout"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"Player", "FilterPhrase"};
		["Function"] = function(Session)
			for _,v in ipairs(Session.Execution.Arguments[1]) do
				Modules.API.ClientCommand(v, Session);
				Modules.API.PromptGui(v, "Alert", {
					Title = "Muted.";
					Content = Session.Execution.Arguments[2]
				})
			end
		end;
	},
	
	{ -- TODO
		["Name"] = "unmute";
		["Aliases"] = {"delmute"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"Player"};
		["Function"] = function(Session)
			for _,v in ipairs(Session.Execution.Arguments[1]) do
				Modules.API.ClientCommand(v, Session);
				Modules.API.PromptGui(v, "Alert", {
					Title = "Unmuted.";
					Content = "Your mute has been removed.";
				})
			end
		end;
	},
	
	{ -- TODO
		["Name"] = "addbantime";
		["Aliases"] = {"addban"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"Number", "Number"};
		["Function"] = function(Session)
				local DS = game:GetService("DataStoreService")
				local BanStore = DS:GetDataStore(Modules.Configuration.BanDatastore)
			
				local Time = Session.Execution.Arguments[2] * 24 * 60 * 60
			
				local Success, Error = pcall(function()
					BanStore:IncrementAsync(tostring(Session.Execution.Arguments[1]), Time)
				end)

				if Success then
					Modules.API.PromptGui(Session.Player.Client, "Alert", {
						Title = "Added Time.";
						Content = "Added bantime for the specified User ID."
					})
				end
		end;
	},
	
}

function CommandsModule.RegisterCommand(Command)
	table.insert(CommandsModule.Commands, Command)
end

function CommandsModule.Init(LoadedModules)
	-- Load LoadedModules to local Module value.
	Modules = LoadedModules
	
	Modules.CommandHandler.RegisterCommandHolder("Moderation", CommandsModule.Commands)
end

return CommandsModule