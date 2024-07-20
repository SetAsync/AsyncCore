local Modules
local CommandsModule = {}
CommandsModule.Commands = {

	{ -- TODO
		["Name"] = "kill";
		["Aliases"] = {"die", "unalive"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"Player"};
		["Function"] = function(Session)
			for _,v in ipairs(Session.Execution.Arguments[1]) do
				if v.Character then
					v.Character.Humanoid.Health = 0
				end
			end
		end;
	},

	{ -- TODO
		["Name"] = "health";
		["Aliases"] = {"sethealth", "makehealth"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"Player", "Number"};
		["Function"] = function(Session)
			for _,v in ipairs(Session.Execution.Arguments[1]) do
				if v.Character then
					v.Character.Humanoid.Health = Session.Execution.Arguments[2]
				end
			end
		end;
	},

	{ -- TODO
		["Name"] = "heal";
		["Aliases"] = {"life", "firstaid"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"Player"};
		["Function"] = function(Session)
			for _,v in ipairs(Session.Execution.Arguments[1]) do
				if v.Character then
					v.Character.Humanoid.Health = 100
				end
			end
		end;
	},

	{ -- DONE
		["Name"] = "invisible";
		["Aliases"] = {"hide", "ghost"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"Player"};
		["Function"] = function(Session)
			for _,v in ipairs(Session.Execution.Arguments[1]) do
				if v.Character then
					for _, BodyPart in ipairs(v.Character:GetDescendants()) do
						if BodyPart:IsA("BasePart") then
							if BodyPart.Transparency == 1 then
								-- Remember Invisible and don't undo at later point.
								if not BodyPart:FindFirstChild("Invisible") then
									Instance.new("Folder", BodyPart).Name = "Invisible"
								end
							else
								BodyPart.Transparency = 1
							end
						end
					end
				end
			end
		end;
	},

	{ -- TODO
		["Name"] = "visible";
		["Aliases"] = {"uninvisible", "unhide", "unghost", "show"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"Player"};
		["Function"] = function(Session)
			for _,v in ipairs(Session.Execution.Arguments[1]) do
				if v.Character then
					for _, BodyPart in ipairs(v.Character:GetDescendants()) do
						if BodyPart:IsA("BasePart") then
							if not BodyPart:FindFirstChild("Invisible") then
								BodyPart.Transparency = 0
							end
						end
					end
				end
			end
		end;
	},

	{ -- DONE
		["Name"] = "forcefield";
		["Aliases"] = {"ff", "god"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"Player"};
		["Function"] = function(Session)
			for _,v in ipairs(Session.Execution.Arguments[1]) do
				if v.Character then
					if not v.Character:FindFirstChild("ForceField") then
						local ForceField = Instance.new("ForceField")
						ForceField.Parent = v.Character
					end
				end
			end
		end;
	},

	{ -- DONE
		["Name"] = "unforcefield";
		["Aliases"] = {"unff", "ungod", "delff"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"Player"};
		["Function"] = function(Session)
			for _,v in ipairs(Session.Execution.Arguments[1]) do
				if v.Character then
					if v.Character:FindFirstChild("ForceField") then
						v.Character.ForceField:Destroy()
					end
				end
			end
		end;
	},

	{ -- TODO
		["Name"] = "name";
		["Aliases"] = {"tag", "setname", "settag"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"Player", "FilterPhrase"};
		["Function"] = function(Session)
			for _,v in ipairs(Session.Execution.Arguments[1]) do
				if v.Character then
					v.Character.Humanoid.DisplayName = Session.Execution.Arguments[2]
				end
			end
		end;
	},

	{ -- TODO
		["Name"] = "jail";
		["Aliases"] = {"box", "prison"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"Player"};
		["Function"] = function(Session)
			for _,v in ipairs(Session.Execution.Arguments[1]) do
				if v.Character and v.Character.PrimaryPart then
					coroutine.wrap(function()
						local JailName = v.UserId.."'s Jail"
						if workspace:FindFirstChild(JailName) then return end
						local NewJail = Modules.API.GetShared().Jail:Clone()

						NewJail.Parent = workspace
						NewJail.Name = JailName

						local IdealPosition = v.Character.PrimaryPart.Position
						local LowestY
						for _, VV in ipairs(v.Character:GetDescendants()) do
							if VV:IsA("BasePart") then
								if (not LowestY) or (VV.Position.Y < LowestY) then
									LowestY = VV.Position.Y
								end 
							end
						end

						IdealPosition = Vector3.new(IdealPosition.X, LowestY, IdealPosition.Z)

						NewJail:MoveTo(IdealPosition)
						v.Character:MoveTo(NewJail.Floor.Position)
					end)()

				end
			end

		end;
	},


	{ -- TODO
		["Name"] = "unjail";
		["Aliases"] = {"unbox", "unprison", "bail", "removebox", "removejail"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"Player"};
		["Function"] = function(Session)
			for _,v in ipairs(Session.Execution.Arguments[1]) do
				if v.Character and v.Character.PrimaryPart then
					local JailName = v.UserId.."'s Jail"
					if workspace:FindFirstChild(JailName) then
						workspace[JailName]:Destroy()
					end
				end
			end
		end;
	},

	{ -- TODO
		["Name"] = "view";
		["Aliases"] = {"watch", "spy", "camera", "setcam"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"Player"};
		["Function"] = function(Session)
			Session["Victim"] = Session.Execution.Arguments[1][1];
			Modules.API.ClientCommand(Session.Player.Client, Session);
			Modules.API.PromptGui(Session.Player.Client, "Notification", {
				Title = "Switched View";
				Content = "Watching "..Session["Victim"].Name.."."
			})
		end;
	},

	{ -- TODO
		["Name"] = "fly";
		["Aliases"] = {"float"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"Player"};
		["Function"] = function(Session)
			for _, target in ipairs(Session.Execution.Arguments[1]) do

				local char = target.Character
				if char then
					local scr = script.Fly:Clone()
					local sVal = Instance.new("NumberValue")
					sVal.Name = 'Speed'
					sVal.Value = 1.35
					sVal.Parent = scr

					local NoclipVal = Instance.new("BoolValue")
					NoclipVal.Name = 'Noclip'
					NoclipVal.Value = false
					NoclipVal.Parent = scr

					scr.Name = "COMMANDER_FLIGHT"

					local part = char:FindFirstChild("HumanoidRootPart")
					if part then
						local oldp = part:FindFirstChild("COMMANDER_FLIGHT_POSITION")
						local oldg = part:FindFirstChild("COMMANDER_FLIGHT_GYRO")
						local olds = part:FindFirstChild("COMMANDER_FLIGHT")
						if oldp then oldp:Destroy() end
						if oldg then oldg:Destroy() end
						if olds then olds:Destroy() end

						local new = scr:Clone()
						local flightPosition = Instance.new("BodyPosition")
						local flightGyro = Instance.new("BodyGyro")

						flightPosition.Name = "COMMANDER_FLIGHT_POSITION"
						flightPosition.MaxForce = Vector3.new(0, 0, 0)
						flightPosition.Position = part.Position
						flightPosition.Parent = part

						flightGyro.Name = "COMMANDER_FLIGHT_GYRO"
						flightGyro.MaxTorque = Vector3.new(0, 0, 0)
						flightGyro.CFrame = part.CFrame
						flightGyro.Parent = part

						new.Parent = part
						new.Disabled = false

						char.Humanoid.PlatformStand = true

					end
				end
			end
		end;
	},

	{ -- TODO
		["Name"] = "unfly";
		["Aliases"] = {"unfloat", "land", "clip", "unclip", "walls"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"Player"};
		["Function"] = function(Session)
			for _, v in ipairs(Session.Execution.Arguments[1]) do
				local SAVE = v.Character.PrimaryPart.Position
				local part = v.Character:FindFirstChild("HumanoidRootPart")
				local Unflied = false
				if part then
					local oldp = part:FindFirstChild("COMMANDER_FLIGHT_POSITION")
					local oldg = part:FindFirstChild("COMMANDER_FLIGHT_GYRO")
					local olds = part:FindFirstChild("COMMANDER_FLIGHT")
					if oldp then oldp:Destroy() Unflied = true end
					if oldg then oldg:Destroy() Unflied = true end
					if olds then olds:Destroy() Unflied = true end
				end
				if Unflied then
					coroutine.wrap(function()
						v:LoadCharacter()
						repeat wait() until v.Character.PrimaryPart
						v.Character:MoveTo(SAVE)
					end)()
				end
			end
		end;
	},

	{ -- TODO
		["Name"] = "noclip";
		["Aliases"] = {"unclip", "nowalls", "thru"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"Player"};
		["Function"] = function(Session)
			for _, target in ipairs(Session.Execution.Arguments[1]) do

				local char = target.Character

				for _,v in ipairs(char:GetDescendants()) do
					local S = pcall(function()
						local x
						x = v.CanCollide
					end)

					if S then
						v.CanCollide = false
					end
				end

				if char then
					local scr = script.Fly:Clone()
					local sVal = Instance.new("NumberValue")
					sVal.Name = 'Speed'
					sVal.Value = 1.35
					sVal.Parent = scr

					local NoclipVal = Instance.new("BoolValue")
					NoclipVal.Name = 'Noclip'
					NoclipVal.Value = true
					NoclipVal.Parent = scr

					scr.Name = "COMMANDER_FLIGHT"

					local part = char:FindFirstChild("HumanoidRootPart")
					if part then
						local oldp = part:FindFirstChild("COMMANDER_FLIGHT_POSITION")
						local oldg = part:FindFirstChild("COMMANDER_FLIGHT_GYRO")
						local olds = part:FindFirstChild("COMMANDER_FLIGHT")
						if oldp then oldp:Destroy() end
						if oldg then oldg:Destroy() end
						if olds then olds:Destroy() end

						local new = scr:Clone()
						local flightPosition = Instance.new("BodyPosition")
						local flightGyro = Instance.new("BodyGyro")

						flightPosition.Name = "COMMANDER_FLIGHT_POSITION"
						flightPosition.MaxForce = Vector3.new(0, 0, 0)
						flightPosition.Position = part.Position
						flightPosition.Parent = part

						flightGyro.Name = "COMMANDER_FLIGHT_GYRO"
						flightGyro.MaxTorque = Vector3.new(0, 0, 0)
						flightGyro.CFrame = part.CFrame
						flightGyro.Parent = part

						new.Parent = part
						new.Disabled = false

						char.Humanoid.PlatformStand = true

					end
				end
			end
		end;
	},

	{ -- TODO
		["Name"] = "refresh";
		["Aliases"] = {"re", "clear"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"Player"};
		["Function"] = function(Session)
			for _,v in ipairs(Session.Execution.Arguments[1]) do
				v:LoadCharacter()
			end
		end;
	},

	{ -- TODO
		["Name"] = "speed";
		["Aliases"] = {"walkspeed", "walk", "setwalkspeed"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"Player", "Number"};
		["Function"] = function(Session)
			for _,v in ipairs(Session.Execution.Arguments[1]) do
				if v.Character then
					v.Character.Humanoid.WalkSpeed = Session.Execution.Arguments[2]
				end
			end
		end;
	},

	{ -- TODO
		["Name"] = "freeze";
		["Aliases"] = {};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"Player"};
		["Function"] = function(Session)
			for _,v in ipairs(Session.Execution.Arguments[1]) do
				if v.Character and v.Character.PrimaryPart then
					v.Character.PrimaryPart.Anchored = true
				end
			end
		end;
	},

	{ -- TODO
		["Name"] = "unfreeze";
		["Aliases"] = {};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"Phrase"};
		["Function"] = function(Session)
			for _,v in ipairs(Session.Execution.Arguments[1]) do
				if v.Character and v.Character.PrimaryPart then
					v.Character.PrimaryPart.Anchored = false
				end
			end
		end;
	},

	{ -- TODO
		["Name"] = "size";
		["Aliases"] = {};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"Player", "Number"};
		["Function"] = function(Session)
			for _,v in ipairs(Session.Execution.Arguments[1]) do
				local Humanoid = v.Character.Humanoid
				if Humanoid then
					local BDS = Humanoid:FindFirstChild('BodyDepthScale')
					local BWS = Humanoid:FindFirstChild('BodyWidthScale')
					local BHS = Humanoid:FindFirstChild('BodyHeightScale')
					local HS = Humanoid:FindFirstChild('HeadScale')

					if BDS and BWS and BHS and HS then
						BDS.Value = Session.Execution.Arguments[2] 
						BWS.Value = Session.Execution.Arguments[2] 
						BHS.Value = Session.Execution.Arguments[2] 
						HS.Value = Session.Execution.Arguments[2] 
					end
				end

			end

		end;
	},
	
	{
		["Name"] = "godmode";
		["Aliases"] = {"god", "makegod"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"Player"};
		["Function"] = function(Session)
			for _, v in ipairs(Session.Execution.Arguments[1]) do
				if v.Character then
					if not v.Character:FindFirstChild("GodMode") then
						local GodMode = Instance.new("ForceField", v.Character)
						GodMode.Name = "GodMode"
						GodMode.Visible = false
					end
				end
			end
		end;
	},

	{
		["Name"] = "ungodmode";
		["Aliases"] = {"ungod", "unmakegod", "nogod"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"Player"};
		["Function"] = function(Session)
			for _, v in ipairs(Session.Execution.Arguments[1]) do
				if v.Character then
					if v.Character:FindFirstChild("GodMode") then
						v.Character:FindFirstChild("GodMode"):Destroy()
					end
				end
			end
		end;
	},
	
	{
		["Name"] = "damage";
		["Aliases"] = {"harm", "hurt"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"Player", "Number"};
		["Function"] = function(Session)
			for _, v in ipairs(Session.Execution.Arguments[1]) do
				if v.Character then
					v.Character.Humanoid:TakeDamage(Session.Execution.Arguments[2])
				end
			end
		end;
	},

	{
		["Name"] = "explode";
		["Aliases"] = {"boom"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"Player"};
		["Function"] = function(Session)
			for _, v in ipairs(Session.Execution.Arguments[1]) do
				if v.Character then
					local explosion = Instance.new("Explosion")
					explosion.Position = v.Character.PrimaryPart.Position
					explosion.Parent = v.Character
					explosion.DestroyJointRadiusPercent = 0
					v.Character:BreakJoints()					
				end
			end
		end;
	},

	{
		["Name"] = "fire";
		["Aliases"] = {"flames"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"Player"};
		["Function"] = function(Session)
			for _, v in ipairs(Session.Execution.Arguments[1]) do
				if v.Character then
					local Fire = Instance.new("Fire", v.Character.PrimaryPart)
					Fire.Name = "AdminSysFire"
				end
			end
		end;
	},

	{
		["Name"] = "unfire";
		["Aliases"] = {"noflames"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"Player"};
		["Function"] = function(Session)
			for _, v in ipairs(Session.Execution.Arguments[1]) do
				if v.Character and v.Character.PrimaryPart:FindFirstChild("AdminSysFire") then
					v.Character.PrimaryPart.AdminSysFire:Destroy()
				end
			end
		end;
	},

	{
		["Name"] = "smoke";
		["Aliases"] = {};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"Player"};
		["Function"] = function(Session)
			for _, v in ipairs(Session.Execution.Arguments[1]) do
				if v.Character then
					local Smoke = Instance.new("Smoke", v.Character.PrimaryPart)
					Smoke.Name = "AdminSysSmoke"
				end
			end
		end;
	},

	{
		["Name"] = "unsmoke";
		["Aliases"] = {"nosmoke"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"Player"};
		["Function"] = function(Session)
			for _, v in ipairs(Session.Execution.Arguments[1]) do
				if v.Character and v.Character.PrimaryPart:FindFirstChild("AdminSysSmoke") then
					v.Character.PrimaryPart.AdminSysSmoke:Destroy()
				end
			end
		end;
	},

	{
		["Name"] = "sparkles";
		["Aliases"] = {"magic"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"Player"};
		["Function"] = function(Session)
			for _, v in ipairs(Session.Execution.Arguments[1]) do
				if v.Character then
					local Smoke = Instance.new("Sparkles", v.Character.PrimaryPart)
					Smoke.Name = "AdminSysSparkles"
				end
			end
		end;
	},

	{
		["Name"] = "unsparkles";
		["Aliases"] = {"nomagic"};
		["Permissions"] = {"Any", {
			{"Rank", 1};
		}};
		["Arguments"] = {"Player"};
		["Function"] = function(Session)
			for _, v in ipairs(Session.Execution.Arguments[1]) do
				if v.Character and v.Character.PrimaryPart:FindFirstChild("AdminSysSparkles") then
					v.Character.PrimaryPart.AdminSysSparkles:Destroy()
				end
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

	Modules.CommandHandler.RegisterCommandHolder("Fun", CommandsModule.Commands)
end

return CommandsModule