
return {
	get = function(key: string): string?
		local result = redis.call("GET", key)
		if result == false then
			return nil
		end
		return result :: string
	end,
	set = function(key: string, value: string | number)
		return redis.call("SET", key, tostring(value))
	end,
}
