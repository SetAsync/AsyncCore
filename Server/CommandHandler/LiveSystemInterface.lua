local Modules
local CommandsModule = {}
CommandsModule.Commands = {
	
	{
		["Name"] = "viewmodules";
		["Aliases"] = {"listmodules","viewsystem","system", "modules"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {};
		["Function"] = function(Session)
			
			local Display = {"Use :module <x> to view a specific module."}
			
			for i,v in pairs(Modules) do
				table.insert(Display, i)
			end
			
			Modules.API.PromptGui(Session.Player.Client, "Statistics", {
				Title = "Loaded Modules";
				Statistics = Display;
			})
		end;
	},
	
	{
		["Name"] = "showmodule";
		["Aliases"] = {"module", "exploremodule"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"Word"};
		["Function"] = function(Session)
			local ModuleName = Session.Execution.Arguments[1]
			local LocatedModule = Modules[ModuleName]
			if LocatedModule then
				local Display = {}
				if type(LocatedModule) ~= "table" then
					table.insert(Display, "None Table")
					table.insert(Display, "Class: "..type(LocatedModule))
					local Default = "Cannot represent as string!"
					pcall(function()
						Default = tostring(LocatedModule)
					end)
					table.insert(Display, Default)
				else
					for i,v in pairs(LocatedModule) do
						table.insert(Display, tostring(i)..": "..tostring(v))
					end
				end

				Modules.API.PromptGui(Session.Player.Client, "Statistics", {
					Title = ModuleName;
					Statistics = Display;
				})
			else
				Modules.API.PromptGui(Session.Player.Client, "Alert", {
					Title = "Invalid Module";
					Content = "Could not locate the specified module.\n(Caps Sensitive!)"
				})
			end
		end;
	},
	
	{
		["Name"] = "unloadsystem";
		["Aliases"] = {"unload", "delsystem", "goodbye"};
		["Permissions"] = {"Any", {
			{"Rank", 3};
		}};
		["Arguments"] = {};
		["Function"] = function(Session)
			print(Modules.LoadArguments)
			Modules.API.PromptGui(Session.Player.Client, "Alert", {
				Title = "Goodbye!";
				Content = "The system will unload in 5 seconds!"
			})
			task.wait(5)
			Modules.Core.UnLoad(true)
		end;
	}
	
}

function CommandsModule.RegisterCommand(Command)
	table.insert(CommandsModule.Commands, Command)
end

function CommandsModule.Init(LoadedModules)
	-- Load LoadedModules to local Module value.
	Modules = LoadedModules
	Modules.CommandHandler.RegisterCommandHolder("Live System Interface", CommandsModule.Commands)
end

return CommandsModule