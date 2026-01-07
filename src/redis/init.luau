local rc = redis.call

return {
    TYPE_STRING = "string",
    TYPE_LIST = "list",
    TYPE_SET = "set",
    TYPE_ZSET = "zset",
    TYPE_HASH = "hash",
    TYPE_STREAM = "stream",
    TYPE_NONE = "none",
	get = function(key: string): string?
		local result = rc("GET", key)
		if result == false then
			return nil
		end
		return result :: string
	end,
	set = function(key: string, value: string | number)
		return rc("SET", key, tostring(value))
	end,
	setnx = function(key: string, value: string | number): boolean
		return rc("SETNX", key, tostring(value)) == 1
	end,
	append = function(key: string, value: string): number
		return rc("APPEND", key, value)
	end,
	strlen = function(key: string): number
		return rc("STRLEN", key)
	end,
	getrange = function(key: string, start: number, stop: number): string
		return rc("GETRANGE", key, start, stop)
	end,
	setrange = function(key: string, offset: number, value: string): number
		return rc("SETRANGE", key, offset, value)
	end,
	mget = function(keys: { string }): { string | boolean }
		return rc("MGET", unpack(keys))
	end,
	mset = function(input: { [string]: string | number }): string
		local args = {}
		for k, v in pairs(input) do
			table.insert(args, k)
			table.insert(args, tostring(v))
		end
		return rc("MSET", unpack(args))
	end,

	del = function(key: string): number
		return rc("DEL", key)
	end,
	exists = function(key: string): boolean
		return rc("EXISTS", key) == 1
	end,
	incr = function(key: string): number
		return rc("INCR", key)
	end,
	decr = function(key: string): number
		return rc("DECR", key)
	end,
	expire = function(key: string, seconds: number): boolean
		return rc("EXPIRE", key, seconds) == 1
	end,
	ttl = function(key: string): number
		return rc("TTL", key)
	end,
    copy = function(source: string, destination: string): number
        return rc("COPY", source, destination)
    end,
    type = function(key: string): string
        return rc("TYPE", key)
    end,

    -- List Commands
    lpush = function(key: string, ...: string | number): number
        return rc("LPUSH", key, ...)
    end,
    rpush = function(key: string, ...: string | number): number
        return rc("RPUSH", key, ...)
    end,
    lpop = function(key: string, count: number?): string | { string } | nil
        if count then
             local result = rc("LPOP", key, count)
             if result == false then return nil end
             return result
        else
             local result = rc("LPOP", key)
             if result == false then return nil end
             return result :: string
        end
    end,
    rpop = function(key: string, count: number?): string | { string } | nil
        if count then
             local result = rc("RPOP", key, count)
             if result == false then return nil end
             return result
        else
             local result = rc("RPOP", key)
             if result == false then return nil end
             return result :: string
        end
    end,
    llen = function(key: string): number
        return rc("LLEN", key)
    end,
    lrange = function(key: string, start: number, stop: number): { string }
        return rc("LRANGE", key, start, stop)
    end,
    lindex = function(key: string, index: number): string?
        local result = rc("LINDEX", key, index)
        if result == false then return nil end
        return result :: string
    end,
    lrem = function(key: string, count: number, value: string): number
        return rc("LREM", key, count, value)
    end,
    lset = function(key: string, index: number, value: string): string
        return rc("LSET", key, index, value)
    end,
    ltrim = function(key: string, start: number, stop: number): string
        return rc("LTRIM", key, start, stop)
    end,

    -- Hash Commands
    hset = function(key: string, field: string, value: string | number): number
        return rc("HSET", key, field, tostring(value))
    end,
    hget = function(key: string, field: string): string?
        local result = rc("HGET", key, field)
        if result == false then return nil end
        return result :: string
    end,
    hmget = function(key: string, ...: string): { string | boolean }
        return rc("HMGET", key, ...)
    end,
    hdel = function(key: string, ...: string): number
        return rc("HDEL", key, ...)
    end,
    hexists = function(key: string, field: string): boolean
        return rc("HEXISTS", key, field) == 1
    end,
    hgetall = function(key: string): { string }
        -- Redis returns list key1, val1, key2, val2...
        return rc("HGETALL", key)
    end,
    hkeys = function(key: string): { string }
        return rc("HKEYS", key)
    end,
    hvals = function(key: string): { string }
        return rc("HVALS", key)
    end,
    hlen = function(key: string): number
        return rc("HLEN", key)
    end,
    hincrby = function(key: string, field: string, increment: number): number
        return rc("HINCRBY", key, field, increment)
    end,

    -- Set Commands
    sadd = function(key: string, ...: string | number): number
        return rc("SADD", key, ...)
    end,
    srem = function(key: string, ...: string | number): number
        return rc("SREM", key, ...)
    end,
    smembers = function(key: string): { string }
        return rc("SMEMBERS", key)
    end,
    sismember = function(key: string, member: string | number): boolean
        return rc("SISMEMBER", key, member) == 1
    end,
    scard = function(key: string): number
        return rc("SCARD", key)
    end,
    spop = function(key: string, count: number?): string | { string } | nil
        if count then
             local result = rc("SPOP", key, count)
             if result == false then return nil end
             return result
        else
             local result = rc("SPOP", key)
             if result == false then return nil end
             return result :: string
        end
    end,
    srandmember = function(key: string, count: number?): string | { string } | nil
        return rc("SRANDMEMBER", key, count)
    end,

    -- Sorted Set Commands
    zadd = function(key: string, ...: string | number): number
        -- Usage: zadd(key, score1, member1, score2, member2, ...)
        return rc("ZADD", key, ...)
    end,
    zrem = function(key: string, ...: string | number): number
        return rc("ZREM", key, ...)
    end,
    zscore = function(key: string, member: string | number): number?
        local result = rc("ZSCORE", key, member)
        if result == false then return nil end
        return tonumber(result)
    end,
    zincrby = function(key: string, increment: number, member: string | number): number?
        return tonumber(rc("ZINCRBY", key, increment, member))
    end,
    zcard = function(key: string): number
        return rc("ZCARD", key)
    end,
    zrange = function(key: string, start: number, stop: number, withscores: boolean?): { string }
        if withscores then
             return rc("ZRANGE", key, start, stop, "WITHSCORES")
        else
             return rc("ZRANGE", key, start, stop)
        end
    end,
    zrevrange = function(key: string, start: number, stop: number, withscores: boolean?): { string }
        if withscores then
             return rc("ZREVRANGE", key, start, stop, "WITHSCORES")
        else
             return rc("ZREVRANGE", key, start, stop)
        end
    end,
    zrank = function(key: string, member: string | number): number?
        local result = rc("ZRANK", key, member)
        if result == false then return nil end
        return result
    end,
    zrevrank = function(key: string, member: string | number): number?
        local result = rc("ZREVRANK", key, member)
        if result == false then return nil end
        return result
    end,
    zcount = function(key: string, min: number | string, max: number | string): number
        return rc("ZCOUNT", key, min, max)
    end,
}
