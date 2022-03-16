local Encyclopedia = _G.Encyclopedia
--[[
[ENCYCLOPEDIA]
-[FSM.lua]--------------
	Create a finite state machine, which is primarily used for tool states, animations, etc. Create
	a FSM at runtime with ease!
	
[SOURCES]: -- thanks to all of these sources. they were all extremely helpful with this implementation
	loleris - MadworkZero/MadFSM // github.com/MadStudioRoblox/Madwork-Zero/blob/main/ServerScriptService/Madwork/Shared/MadFSM.lua
	Table Flip Games - FSM videos // youtube.com/watch?v=nSNx5Nb3_fk
	Michael Sipster - The Theory of Computation
	
[HOW-TO-USE]:
	Each state is defined through a table. States should ALWAYS have at least two elements:
		- Name:			[string] - name of the state
		- Duration:		[number] - how long the state should last
			- 0 implies the state will loop forever, until acted on
		

	[TRANSITION FUNCTIONS]: -- [ALL OPTIONAL]
		Enter(old_state) - [boolean] - can you enter this state?
			old_state:		[String]
			@ret:			[boolean] -- true: can enter, false: cannot enter
			
		Start() - [boolean] - function to be fired when successfully starting the state
			@ret:			nil
		
		Exit(new_state) - [boolean] - can you exit this state?
			new_state:		[String]
			@ret:			[boolean] -- true: can exit, false: cannot exit
		
		Cancel() - [void] - function that fires on cancel [FSM yields during this]
			@ret:			nil
			
		Complete()
			@ret:			nil

	[EXAMPLE USAGE] - [PAINTBALL GUN]:
	local MyFSM = FSM.new()
	local states = {
		I{
			Name = "Idle",
			Duration = 0
		},
		{
			Name = "Shoot",
			Duration = fire_rate, -- some arbitrary number for FireRate
			Enter = function(old_state)
				return has_ammo -- can only shoot if player has ammo
			end,
			
			Start = function()
				-- SHOOT PAINTBALL
			end,
			
			Complete = function()
				if automatic == true 
					and mouse_still_down then -- if the gun is automatic, continue shooting
					MyFSM:Set("Shoot")
				else
					MyFSM:Set("Idle")
				end
			end
		}
	}



[OBJECT][FSM]:
	[Members]:
		Duration:			[number] - How long the current state should last.
		Progress:			[number] - (CurrentTime - StartTime)/Duration
		StartTime:			[number] - Time the current state started
		CompleteTime:		[number] - Time the current state ended

	[Methods]:
		FSM.new() - [FSM] - constructor method for the FSM
			@ret:		[FSM]
		
		FSM:DefineStates(states) - [void] - Defines the states for the FSM.
			states:		[table]
			@ret:		nil
			
		FSM:Set(name) - [void] - sets the current state to the state with name 'name'.
			name:		[string]
			@ret:		nil
			
		FSM:Update() - [void] - run this on .Stepped
			@ret:		nil

--]]

local SETTINGS = {
	
}

-- Module table:
local FSM = {
	
}
FSM.__index = FSM

----- Private functions -----
local function GetTimeSource()
	return workspace:GetServerTimeNow()
end

local function _transitionStates(old, new)
	-- cannot transition to a state that's nil
	if new == nil then return false end
	
	old = old or {}
	
	if old.Exit ~= nil and old.Exit(new.Name) == false then
		return false
	end
	
	if new.Enter ~= nil and new.Enter(old.Name) == false then
		return false
	end
	
	return true
end

----- Global methods -----
function FSM.new()
	return setmetatable({
		Duration = 0,
		Progress = 0,
		CompleteTime = nil,
		
		_currentState = nil,
		_previousState = nil,
		_cancelling = false,
		_t = GetTimeSource
	}, FSM)
end

function FSM:DefineStates(states)
	assert(self._states == nil, 
		"[FSM] States have already been defined.")
	
	self._states = {}
	
	for _, state in ipairs(states) do
		self._states[state.Name] = state
	end
end

function FSM:Set(name)
	local state = self._states[name]
	assert(state ~= nil, 
		("[FSM] Could not find state with name '%s'"):format(name))
	
	self:_EnterState(state)
end

function FSM:_EnterState(nextState)
	if self._cancelling == true then return end
	
	if _transitionStates(self._currentState, nextState) == false then 
		return
	end
	
	self._previousState = self._currentState
	
	if self.CompleteTime == nil then
		local curr = self._currentState
		
		if curr ~= nil and curr.Cancel ~= nil then
			self._cancelling = true
			curr.Cancel()
			self._cancelling = false
		end
	end
	
	self._currentState = nextState
	
	self.Duration = nextState.Duration
	self.StartTime = self._t()
	self.Progress = 0
	self.CompleteTime = nil
	
	if nextState.Start ~= nil then 
		nextState.Start()
	end
end

function FSM:Update()
	if self._currentState == nil or self.Duration == 0 or self._cancelling == true then return end
	
	local t = self._t()
	local dt = t - self.StartTime
	
	self.Progress = math.clamp(dt/self.Duration, 0, 1)
	
	if self.Progress == 1 then
		local state = self._currentState
		
		self.CompleteTime = t
		
		if state.Complete ~= nil then
			state.Complete()
		else
			self:Set(state.Name)
		end
		
		return
	end
end

return FSM