--// API.lua

local API = {}
local Modules
local Endpoint = game.ReplicatedStorage:WaitForChild("Admin System Shared").GUIPrompt
local CommandEndpoint = Endpoint.Parent.ClientCommand

-- // PromptGui - Pretty Obvious
function API.PromptGui(Player, Type, Payload)
	if Player == "All" then
		Endpoint:FireAllClients(Type, Payload)
	else
		Endpoint:FireClient(Player, Type, Payload)
	end
end

function API.GetShared()
	return Endpoint.Parent
end

-- // UserMayHarm - Determine's whether "User" may moderate "Harm".
function API.UserMayHarm(User, Harm)
	local UserRank = User:FindFirstChild("AdminRank")
	local HarmRank = Harm:FindFirstChild("AdminRank")
	
	if UserRank and HarmRank then
		UserRank = UserRank.Value
		HarmRank = HarmRank.Value
		return (UserRank > HarmRank)
	end
end

-- // DumbString - Returns the found string given an option which loosely represents it.
function API.DumbString(Haystack, Needle)
	Needle = Needle:lower()
	
	for _, v in ipairs(Haystack) do
		local vObject = v
		if type(v) ~= "string" then
			vObject = v
			v = v.Name
		end
		
		v = v:lower()
		
		if string.sub(v, 1, #Needle) == Needle then
			return vObject
		end
	end
end

function API.ClientCommand(Client, Session)
	CommandEndpoint:FireClient(Client, Session)
end


function API.Init(LoadedModules)
	Modules = LoadedModules
end	


return API