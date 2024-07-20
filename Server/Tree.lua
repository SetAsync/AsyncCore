-- Tree.lua

local Tree = {}

-- Terms
local Terms = {}
Terms["Property"] = function(Object, Name, Value)
	-- If object has the property.
	local FoundProperty
	local Success = pcall(function()
		FoundProperty = Object[Name]
	end)
	if not Success then
		return false
	end

	-- If property is value.
	if (not Value) or (FoundProperty == Value) then
		return true
	end
	return false
end

Terms["Attribute"] = function(Object, Name, Value)
	-- If object has the property.
	local FoundProperty
	local Success = pcall(function()
		FoundProperty = Object:GetAttribute(Name)
	end)
	if (not Success) or (not FoundProperty) then
		return false
	end

	-- If attribute is value.
	if (not Value) or (FoundProperty == Value) then
		return true
	end
	return false
end

Terms["Function"] = function(Object, Function)
	return Function(Object) or false
end

Terms["Tree"] = function(Object, TreeFunction, ...)
	return Tree[TreeFunction](Object, ...)
end


Tree.ObjectMeetsTerm = function(Object, TermName, PackedTermArguments)
	return Terms[TermName](Object, table.unpack(PackedTermArguments))
end

-- Main Functions
function Tree.ObjectMeetsTerms(Object, TermArguments)
	for _, Term in ipairs(TermArguments) do
		local Term = {table.unpack(Term)}
		local TermName = Term[1]
		table.remove(Term, 1)
		
		if not Tree.ObjectMeetsTerm(Object, TermName, Term) then
			return false
		end
	end
	return true
end

function Tree.FindFirstElementOfList(List, Terms)
	for _, Applicant in ipairs(List) do
		if Tree.ObjectMeetsTerms(Applicant, Terms) then
			return Applicant
		end
	end
	return false
end

function Tree.FindFirstChild(Object, Terms)
	return Tree.FindFirstElementOfList(Object:GetChildren(), Terms)
end

function Tree.FindFirstDescendant(Object, Terms)
	return Tree.FindFirstElementOfList(Object:GetDescendants(), Terms)
end

function Tree.FindFirstAncestor(Object, Terms)
	while true do
		if Tree.ObjectMeetsTerms(Object, Terms) then
			return Object
		end
		Object = Object.Parent
		if not Object then
			return false
		end
	end
end

return Tree
