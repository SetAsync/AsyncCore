-- MainModule.LUA | SETASYNC.ME | 2023

local AsyncAdminCore = {}
local Shared, Server
AsyncAdminCore.Modules = false

function AsyncAdminCore.Load(System, ImportModules, Config)
	local LOADARGUMENTS = {System, ImportModules, Config}
	-- Initialize
	Shared = script.Shared
	Server = script.Server
	Shared.Parent = game.ReplicatedStorage
	Shared.Name = "Admin System Shared"


	
	-- Load Modules
	AsyncAdminCore.Modules = {LoadArguments = LOADARGUMENTS, System = System, Core = AsyncAdminCore, Configuration = Config or require(System.Configuration), CustomFeatures = require(System["Custom Features"])};
	
	-- Check Config
	local BackupConfig = {
		Init = function() warn("Loading Admin System...") end;
		Ranks = {};
		CustomPermissionsChecks = {};
		BanDatastore = "BanDatastore";
		CommandPrefix = "!";
		OverwriteCommands = {};

		-- ADVANCED SETTINGS

		LogLimit = 100;
		CommandSplit = "|";
		CheckInRank = 1;
	}
	for i,v in pairs(BackupConfig) do
		if AsyncAdminCore.Modules.Configuration[i] == nil then
			AsyncAdminCore.Modules.Configuration[i] = v;
		end
	end
	
	if ImportModules then
		for _, v in ipairs(ImportModules) do
			if v:IsA("ModuleScript") and v:GetAttribute("AsyncAdminModule") then
				if AsyncAdminCore.Modules[v.Name] then
					warn("Dublicate import module "..v.Name..", dublicate not loaded.")
				else
					AsyncAdminCore.Modules[v.Name] = require(v);
				end
			end
		end
	end
	
	for _,v in ipairs(Server:GetDescendants()) do
		if v:IsA("ModuleScript") and v:GetAttribute("AsyncAdminModule") then
			if AsyncAdminCore.Modules[v.Name] then
				warn("Dublicate module "..v.Name..", dublicate not loaded.")
			else
				AsyncAdminCore.Modules[v.Name] = require(v);
			end
		end
	end
		
	-- Initialize Modules
	local function InitializeModule(ModuleName, ModuleValue, InitType)
		local Success, Error = pcall(function()
			if type(ModuleValue) == "table" then
				if ModuleValue[InitType] then
					ModuleValue[InitType](AsyncAdminCore.Modules)
				end
			end
		end)
		if not Success then
			warn("ADMIN SYSTEM -> "..ModuleName.." failed to load. "..Error)
		end
		return Success
	end
	
	-- FirstInit
	for ModuleName, ModuleValue in pairs(AsyncAdminCore.Modules) do
		InitializeModule(ModuleName, ModuleValue, "FirstInit")
	end
	
	-- PreInit
	for ModuleName, ModuleValue in pairs(AsyncAdminCore.Modules) do
		InitializeModule(ModuleName, ModuleValue, "PreInit")
	end
	
	-- Init
	for ModuleName, ModuleValue in pairs(AsyncAdminCore.Modules) do
		InitializeModule(ModuleName, ModuleValue, "Init")
	end
	
	-- LastInit
	for ModuleName, ModuleValue in pairs(AsyncAdminCore.Modules) do
		InitializeModule(ModuleName, ModuleValue, "LastInit")
	end
	
	
	-- Green Light
	script.Name = "AsyncAdminCore"
	script.Parent = game:GetService("ServerScriptService")
	-- For external scripts.
end

function AsyncAdminCore.UnLoad(DestroyCore)
	if AsyncAdminCore.Modules then
		for moduleName, module in pairs(AsyncAdminCore.Modules) do
			if type(module) == "table" then
				if module["DeInit"] then
					print("DeInit "..moduleName)
					module.DeInit()
				else
					print("No DeInit for "..moduleName)
				end
			end
		end
	end
	
	--Shared:Destroy()
	if DestroyCore then
		--script:Destroy() -- The same as Server:Destroy()
	end
end

return AsyncAdminCore
