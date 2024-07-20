--// LOCAL COMMANDS
--// WARNING - THIS WILL BE LOADED BY A LOCALSCRIPT.
--|| NO CONFIDENTIAL INFORMATION!

local LocalCommands = {
	
	["mute"] = function(Session)
		game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false);
	end;
	
	["unmute"] = function(Session)
		game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true);
	end;
	
	["view"] = function(Session)
		local Player = Session.Victim
		if Player.Character and Player.Character.Humanoid then
			Player = Player.Character.Humanoid
			workspace.CurrentCamera.CameraSubject = Player;
		end
	end,
	
}

return LocalCommands