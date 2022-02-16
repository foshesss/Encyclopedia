local Exception = {
    _type = "exception"
}
Exception.__index = Exception

function Exception.new(defaultMessage)
    return setmetatable({
        _defaultMessage = defaultMessage
    }, Exception)
end

function Exception:Throw(message)
    local newException = {
        message = message or self._defaultMessage,
    }
    
    function newException.isFrom(base)
        return base == self
    end
    
    return newException
end

function Exception:DidCreate(exception)
    return exception.isFrom(self)
end

--@static
function Exception:IsAnException(data)
    return type(data) == "table" and data._type and data._type == self._type
end

return Exception