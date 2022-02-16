local Exception = {
	
}
Exception.__index = Exception

function Exception.new(name, msg)
	return setmetatable({
		__type = name,
		_msg = msg
	})
end

return Exception