return {
    TYPE_STRING = "string",
    TYPE_LIST = "list",
    TYPE_SET = "set",
    TYPE_ZSET = "zset",
    TYPE_HASH = "hash",
    TYPE_STREAM = "stream",
    TYPE_NONE = "none",
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
	del = function(key: string): number
		return redis.call("DEL", key)
	end,
	exists = function(key: string): boolean
		return redis.call("EXISTS", key) == 1
	end,
	incr = function(key: string): number
		return redis.call("INCR", key)
	end,
	decr = function(key: string): number
		return redis.call("DECR", key)
	end,
	expire = function(key: string, seconds: number): boolean
		return redis.call("EXPIRE", key, seconds) == 1
	end,
	ttl = function(key: string): number
		return redis.call("TTL", key)
	end,
    copy = function(source: string, destination: string): number
        return redis.call("COPY", source, destination)
    end,
    type = function(key: string): string
        return redis.call("TYPE", key)
    end,
}
