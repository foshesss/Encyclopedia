--[[
[ENCYCLOPEDIA]
-[Set.lua]---------------
	A collection that contains no duplicate elements. NOTE: Be EXTREMELY careful when placing mutable 
	objects within a Set. The Set will not consistently check if objects within it are equal.
	
	Directly modifying _set in any way may affect the size of it, so be weary. Default to using
	the provided methods for any modifications.
	
	




--]]


local SETTINGS = {
	
}

local Set = {
	
}
Set.__index = Set

function Set.new(arr)
	return setmetatable({
		_set = {},
		_size = 0
	}, Set)
end


return Set
