--[[
[ENCYCLOPEDIA]
-[MathPlus.lua]--------------------
	This is an extension to the 'math' library. Added onto whenever I need a new math function. Sources
	and credits can be found above each method.
	
[MathPlus][Methods]:
	MathPlus.RandomValue(state) - [number] - returns a random number, based on a given state,
		state:		[Random] - [OPTIONAL]
		@ret:		[number]
		
	MathPlus.RandomGaussian(mean, stdDev, state) - [number] - returns a random number based on gaussian distribution
		mean:		[number] - default value: 0
		stdDev:		[number] - default value: 1
		state:		[Random] - [OPTIONAL]
		@ret:		[number]
		
	MathPlus.RandomPointOnSphere(state) - [Vector3] - returns a random point on a sphere, using .RandomGaussian
		state:		[Random] - [OPTIONAL]
		@ret:		[Vector3]
		
	MathPlus.NumberToClockTime(number) - [string] - returns a number in time format ("00:00")
		number:		[integer] -- if decimals are provided, the number will round down.
		@ret:		[string]
		
		Example usage:
			local n = 500.54745
			print(MathPlus.NumberToClockTime(n)) -- prints "08:20"

--]]

local MathPlus = {
	
}

----- Private variables -----
local rand = Random.new()

----- Global methods -----
function MathPlus.RandomValue(state)
	state = state or rand
	return (1 - state:NextNumber())
end

-- gianlucamancusi.com/wordpress/2017/05/31
function MathPlus.RandomGaussian(mean, stdDev, state)
	stdDev = stdDev or 1
	mean = mean or 0
	
	local theta = 2 * math.pi * MathPlus.RandomValue(state)
	local rho = math.sqrt(-2 * math.log(MathPlus.RandomValue(state)))
	local scale = stdDev * rho
	
	return mean + scale * math.cos(theta)
end

-- math.stackexchange.com/a/1585996
function MathPlus.RandomPointOnSphere(state)
	local x = MathPlus.RandomGaussian(0, 1, state)
	local y = MathPlus.RandomGaussian(0, 1, state)
	local z = MathPlus.RandomGaussian(0, 1, state)
	
	return Vector3.new(x, y, z).Unit
end

function MathPlus.NumberToClockTime(number)
	number = math.floor(number)
	local minutes = math.floor(number/60)
	local seconds = number % 60

	return ("%02d:%02d"):format(minutes, seconds)
end

return MathPlus