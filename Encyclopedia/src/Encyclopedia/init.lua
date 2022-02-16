--[[
[ENCYCLOPEDIA]
-[Encyclopedia.lua]------------------------
	This is a framework, created by 'foshes'. This is what powers most of my games. Feel free to
	use it, fork it, and do whatever you want with it. Some basic functionality is listed below:
	
[HOW TO USE]:
	[SERVER]:
		[INITIALIZE]: -- some Script
			local Encyclopedia = require(script.Encyclopedia)
			
		[OTHER SCRIPTS]:
			local Encyclopedia = _G.Encyclopedia
			
	[CLIENT]:
		[INITIALIZE]: -- some LocalScript
			local ReplicatedStorage = game:GetService("ReplicatedStorage")
			local Encyclopedia = require(ReplicatedStorage.Encyclopedia)
			
		[OTHER SCRIPTS]:
			local Encyclopedia = _G.Encyclopedia
		
[Encyclopedia]:

	[Methods]:
		Encyclopedia.GetService(service) - [table] - retrieves the target service module
			service:		[string]
			@ret: 			[table]
			
		Encyclopedia.GetUtil(name) - [table] - retrieves the target utility module
			name:			[string]
			@ret: 			[table]
			
		Encyclopedia.GetMaid() - [Maid] - creates and returns a new Maid object.
			@ret:			[Maid] - by Quenty
			
		Encyclopedia.CreateSignal() - [Signal] - creates and returns a new custom Signal object.
			@ret:			[Signal] - by Quenty
	
		Encyclopedia.NewInstance(class, properties) - [Instance] - creates an instance of 'class' with specified properties
			class:			[name]
			properties:		[table] - dictionary
			@ret:			[Instance]
			
			Example usage:
				local p = Encyclopedia.NewInstance("Part", {
					Color = Color3.fromRGB(255, 50, 43),
					Name = "Epic Sauce",
					Parent = workspace -- Parent is 'workspace' by default
				})
			
		Encyclopedia.TraversePath(path, origin) - [Instance] - traverse a string path
			path:			[string]
			origin:			[Instance]
			@ret:			[Instance]
			
			Example usage:	
				Encyclopedia.TraversePath("Resources.Item.LinkedSword", ReplicatedStorage)
					- Traverses through ReplicatedStorage.Resources.Item.LinkedSword to find
					the target. In this case, 'LinkedSword'
			
		Encyclopedia.DeepCopy(original) - [table] - deep copies any table.
			original:		[table]
			@ret:			[table] - deep copied version of original
		
		Encyclopedia.SafeTableRemove(tbl, element) - [boolean] - safely removes an element from a table
			tbl:			[table]
			element:		[generic]
			@ret:			[boolean]
			
			Reason for creation:
				local arr = {1, 2, 3}
				table.remove(arr, table.find(arr, 4)) -- removes 3
				
				This method prevents this^ from happening.
	
--]]

local SETTINGS = {
	Name = "Encyclopedia"
}

-- Encyclopedia module:
local Encyclopedia = {

}
_G.Encyclopedia = Encyclopedia

----- Loaded Services -----
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

----- Private Variables -----
local Services = (if RunService:IsServer() == true then
		script.Services 
	else 
		nil)

local SharedServices = script.SharedServices
local Loaded_Services = {}

---- Utils -----
local Utils = script.Utils
local Maid = require(Utils.Maid)
local Signal = require(Utils.Signal)

----- Global methods -----
function Encyclopedia.GetService(name)
	local service = Loaded_Services[name]
	if service ~= nil then return service end
	
	service = SharedServices:FindFirstChild(name)
	
	if service == nil and Services ~= nil then
		service = Services:FindFirstChild(name)
	end
	
	assert(service ~= nil, 
		"[Encyclopedia] Could not find \""..name.."\"")
	assert(service:IsA("ModuleScript") == true,
		"[Encyclopedia] \""..name.."\" is not a ModuleScript.")
	
	service = require(service)
	Loaded_Services[name] = service
	
	print("\""..name.."\" has been loaded for the first time.")
	return service
end

function Encyclopedia.GetUtil(name)
	local util = Utils:FindFirstChild(name)
	assert(util ~= nil, string.format("[Encyclopedia] Util '%s' does not exist.", name))

	return require(util)
end

-- Credit: @Quenty
function Encyclopedia.GetMaid()
	return Maid.new()
end

-- Credit: @Quenty
function Encyclopedia.CreateSignal()
	return Signal.new()
end

-- Credit: @loleris
function Encyclopedia.NewInstance(class, properties)
	local instance = Instance.new(class)
	for k, v in pairs(properties) do
		if k ~= "Parent" then
			instance[k] = v
		end
	end
	instance.Parent = properties.Parent or workspace
	return instance
end

function Encyclopedia.TraversePath(path, origin)
	local t = origin

	for _, path in ipairs(string.split(path, '.')) do
		t = t[path]
	end

	return t:Clone()
end

function Encyclopedia.SafeTableRemove(tbl, element)
	local index = table.find(tbl, element)
	if index ~= nil then
		table.remove(tbl, index)
		return true
	end
	return false
end

function Encyclopedia.DeepCopy(original)
	local copy = {}
	for k, v in pairs(original) do
		if type(v) == "table" then
			v = Encyclopedia.DeepCopy(v)
		end
		copy[k] = v
	end
	return copy
end

-- Initialize:
if RunService:IsServer() == true then
	Services.Parent = game:GetService("ServerStorage")
	script.Parent = ReplicatedStorage
end

return Encyclopedia