local Encyclopedia = _G.Encyclopedia
--[[
[ENCYCLOPEDIA]
-[FSM.lua]---------------
	Finite State Machine implementation, catered towards tool behaviors, animations, etc.
	
	Credits:
		Michael Sipster - Introduction to the Theory of Computation
		loleris - Madwork/MadFSM - github.com/MadStudioRoblox/Madwork-Zero/blob/main/ServerScriptService/Madwork/Shared/MadFSM.lua
		


--]]

local SETTINGS = {
	States = {
		"Entering",
		"Start",
		"Leaving",
		"Cancel",
		"Complete"
	},
	
	EventNames = {
		"Start",
		"Cancel",
		"Complete"
	}
}

-- FSM object:
local FSM = {
	
}
FSM.__index = FSM

----- Utils -----
local Stack = Encyclopedia.GetUtil("Stack")

----- Private functions ----
local function TimeSource()
	return workspace:GetServerTimeNow()
end

----- Global methods -----
function FSM.new()
	local Maid = Encyclopedia.GetMaid()
	local self = setmetatable({
		_initialized = false,
		_maid = Maid,
		
		State = nil,
		Duration = 0,
		StartTime = 0,
		Progress = 0,

		_states = nil,
		_set_stack = Stack.new(),
		_complete_time = nil,
		_time_source = TimeSource
	}, FSM)
	
	for _, event in ipairs(SETTINGS.EventNames) do		
		self["On"..event] = Encyclopedia.CreateSignal()
		Maid:GiveTask(self["On"..event])
	end
	
	return self
end

function FSM:DefineStates(states)
	
end

function FSM:Clean()
	self._cleaned = true
	self._maid:DoCleaning()
	self._set_stack:Clean()
end


return FSM
