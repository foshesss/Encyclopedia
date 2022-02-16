local Encyclopedia = _G.Encyclopedia
--[[
[ENCYCLOPEDIA]
-[Stack.lua]---------------
	The Stack class represents a last-in-first-out (LIFO) stack of objects. The usual push and pop operations 
	are provided, as well as a method to peek at the top item on the stack, a method to test for whether 
	the stack is empty, and a method to search the stack for an item and discover how far it is from the top.

	When a stack is first created, it contains no items.
	
[Object][Events]:
	Stack.ItemAdded:Connect(e)
		Fires whenever Stack:Push() is called. Argument is the item that was pushed.
	end)
	
	Stack.ItemRemoved:Connect(e)
		Fires whenever Stack:Pop() is called. Argument is the item that was popped.
	end)

[Object][Exceptions]:
	[EmptyStackException] - throws if called when stack is empty
	[InactiveStackException] - stack is inactive and can no longer be used.
	
[Object][Methods]:
	Stack.new() - [Stack] - Constructor. Creates a stack with no items.
		@ret:	[Stack]
	
	Stack:IsEmpty() - [boolean] - Returns true if the stack has on items in it. Returns false otherwise.
		@ret: 	[boolean]
		@throws:	
			[InactiveStackException]
		
	Stack:Push(e) - [generic] - Pushes the argument onto the top of the stack. Returns the argument.
		e:			[generic]
		@ret:		[generic] - returns e
		@throws:
			[InactiveStackException]

	Stack:Pop() - [generic] - Pops and returns the top-most value in the stack
		@ret:		[generic]
		@throws:	
			[InactiveStackException]
			[EmptyStackException]
		
	Stack:Peek() - [[generic] - Returns the top-most value in the stack. -- DOES NOT MODIFY STACK --
		@ret:		[generic]
		@throws:	
			[InactiveStackException]
			[EmptyStackException]
		
	Stack:Seach(e) - [integer] - Finds 'e' in the stack if it is there. -- DOES NOT MODIFY STACK --
		@ret:		[integer] -- position of 'e' in the stack or -1
		@throws:	
			[InactiveStackException]
	
	Stack:IsActive() - [boolean] - returns if a stack has been cleaned or not.
		@ret:		[boolean]
	
	Stack:Clean() - [void] - Deactives the stack, destroying all connections.
		@ret: 		[nil]
		@throws:	
			[InactiveStackException]

--]]

local SETTINGS = {
	Exception = {
		InactiveStackException = "[Stack][InactiveStackException] This stack is no longer active.",
		EmptyStackException = "[Stack][EmptyStackException] Cannot peek if the Stack is empty."
	}
}

-- Module table:
local Stack = {
	
}
Stack.__index = Stack

function Stack.new()
	return setmetatable({
		_stack = {},
		_cleaned = false,
		_ExternalListenerFlag = false,
		
		-- events
		ItemAdded = Encyclopedia.CreateSignal(),
		ItemRemoved = Encyclopedia.CreateSignal()
	}, Stack)
end

function Stack:IsEmpty()
	assert(Stack:IsActive() == true, 
		SETTINGS.Exception.InactiveStackException)
	
	return #self._stack == 0
end

function Stack:Push(e)
	assert(Stack:IsActive() == true, 
		SETTINGS.Exception.InactiveStackException)
		
	table.insert(self._stack, e)
	self.ItemAdded:Fire(e)
	return e
end

function Stack:Pop()
	assert(Stack:IsActive() == true, 
		SETTINGS.Exception.InactiveStackException)
	assert(self:IsEmpty() == false, 
		SETTINGS.Exception.EmptyStackException)
	
	local e = table.remove(self._stack)
	self.ItemRemoved:Fire(e)
	return e
end

function Stack:Peek()
	assert(Stack:IsActive() == true, 
		SETTINGS.Exception.InactiveStackException)
	assert(self:IsEmpty() == false, 
		SETTINGS.Exception.EmptyStackException)
	
	return self._stack[#self._stack]
end

function Stack:Search(e)
	assert(Stack:IsActive() == true, 
		SETTINGS.Exception.InactiveStackException)
	
	return table.find(self._stack, e) or -1
end

function Stack:IsActive()
	return self._cleaned == false
end

function Stack:Clean()
	assert(Stack:IsActive() == true, 
		SETTINGS.Exception.InactiveStackException)
	
	self._cleaned = true
	
	self.ItemAdded:Destroy()
	self.ItemRemoved:Destroy()
	
	table.clear(self._stack)
	self._stack = nil
	
	self.ItemAdded = nil
	self.ItemRemoved = nil
end


return Stack
