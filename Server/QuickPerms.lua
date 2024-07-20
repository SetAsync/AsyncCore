--// QuickPerms_2
--[[
- Bug Fixes
- Marketplace Integration
- Cleaner Code
--]]
local QuickPerms, PermissionCheckTypes,PermissionChecks = {}, {}, {}

PermissionChecks["gamepass"] = function(Player, GamepassID)
	return game:GetService("MarketplaceService"):UserOwnsGamePassAsync(Player.UserId, GamepassID)
end

PermissionChecks["player"] = function(Player, Property, Value)
	return (Player[Property] == Value)
end

PermissionChecks["function"] = function(Player, Function, ...)
	return Function(Player, ...)
end

PermissionChecks["group"] = function(Player, GroupID, minRankID, maxRankID)
	local Rank = Player:GetRankInGroup(GroupID)
	if minRankID then
		if not (Rank >= minRankID) then
			return
		end
	end
	if maxRankID then
		if not (Rank <= maxRankID) then
			return
		end
	end
	return (Rank ~= 0)
end

PermissionChecks["gamecreator"] = function(Player)
	return (Player.UserId == game.CreatorId)
end

PermissionChecks["friends"] = function(Player, FriendID, AllowedValue)
	if AllowedValue == nil then
		AllowedValue = true
	end
	return (Player:IsFriendsWith(FriendID) == AllowedValue)
end

PermissionChecks["checkpermissions"] = function(Player, Type, Permissions)
	Type = Type:lower()
	return PermissionCheckTypes[Type](Player, Permissions)
end

PermissionChecks["team"] = function(Player, TeamName)
	return ((Player.Team) and (Player.Team.Name == TeamName))
end

PermissionChecks["hdadminrank"] = function(Player, minRankID, maxRankID)
	-- Get HD
	local HDMain = game:GetService("ReplicatedStorage"):WaitForChild("HDAdminSetup")
	if not HDMain then
		return
	end
	HDMain = require(HDMain):GetMain()
	local HD = HDMain:GetModule("API")
	-- Check Rank
	local Rank = HD:GetRank(Player)
	if minRankID then
		if not (Rank >= minRankID) then
			return
		end
	end
	if maxRankID then
		if not (Rank <= maxRankID) then
			return
		end
	end
	return (Rank ~= 0)
end

function PlayerHasPermission(Player, Permission)
	local Copy = {}
	local CheckName
	for i,v in ipairs(Permission) do
		if i == 1 then
			CheckName = v
		else
			table.insert(Copy, v)
		end
	end

	CheckName = CheckName:lower()
	return PermissionChecks[CheckName](Player, table.unpack(Copy))
end

-- // PermissionCheckTypes
function PermissionCheckTypes.all(Player, Permissions)
	if #Permissions == 0 then
		return false
	end
	
	for _, v in ipairs(Permissions) do
		if not PlayerHasPermission(Player, v) then
			return false
		end
	end
	return true
end

function PermissionCheckTypes.any(Player, Permissions)
	for _, v in ipairs(Permissions) do
		if PlayerHasPermission(Player, v) then
			return true
		end
	end
	return false	
end

function PermissionCheckTypes.exclusive(Player, Permissions)
	local Granted = false
	for _, v in ipairs(Permissions) do
		if PlayerHasPermission(Player, v) then
			if Granted then
				return false
			end
			Granted = true
		end
	end
	return Granted	
end

function PermissionCheckTypes.none(Player, Permissions)
	for _, v in ipairs(Permissions) do
		if PlayerHasPermission(Player, v) then
			return false
		end
	end
	return true
end

-- // Main
Main = function(Player, Type, Permissions)
	Type = Type:lower()
	if PermissionCheckTypes[Type] then
		return PermissionCheckTypes[Type](Player, Permissions)
	else
		warn("Invalid PermissionCheckType:", Type)
	end
end

Init = function(...)
	if ... then
		for Name, Function in pairs(...) do
			PermissionChecks[Name:lower()] = Function
		end
	end
	return Main
end

return {Init = Init};
