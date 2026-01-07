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
	setnx = function(key: string, value: string | number): boolean
		return redis.call("SETNX", key, tostring(value)) == 1
	end,
	append = function(key: string, value: string): number
		return redis.call("APPEND", key, value)
	end,
	strlen = function(key: string): number
		return redis.call("STRLEN", key)
	end,
	getrange = function(key: string, start: number, stop: number): string
		return redis.call("GETRANGE", key, start, stop)
	end,
	setrange = function(key: string, offset: number, value: string): number
		return redis.call("SETRANGE", key, offset, value)
	end,
	mget = function(keys: { string }): { string | boolean }
		return redis.call("MGET", table.unpack(keys))
	end,
	mset = function(pairs: { [string]: string | number }): string
		local args = {}
		for k, v in pairs do
			table.insert(args, k)
			table.insert(args, tostring(v))
		end
		return redis.call("MSET", table.unpack(args))
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

    -- List Commands
    lpush = function(key: string, ...: string | number): number
        return redis.call("LPUSH", key, ...)
    end,
    rpush = function(key: string, ...: string | number): number
        return redis.call("RPUSH", key, ...)
    end,
    lpop = function(key: string, count: number?): string | { string } | nil
        if count then
             local result = redis.call("LPOP", key, count)
             if result == false then return nil end
             return result
        else
             local result = redis.call("LPOP", key)
             if result == false then return nil end
             return result :: string
        end
    end,
    rpop = function(key: string, count: number?): string | { string } | nil
        if count then
             local result = redis.call("RPOP", key, count)
             if result == false then return nil end
             return result
        else
             local result = redis.call("RPOP", key)
             if result == false then return nil end
             return result :: string
        end
    end,
    llen = function(key: string): number
        return redis.call("LLEN", key)
    end,
    lrange = function(key: string, start: number, stop: number): { string }
        return redis.call("LRANGE", key, start, stop)
    end,
    lindex = function(key: string, index: number): string?
        local result = redis.call("LINDEX", key, index)
        if result == false then return nil end
        return result :: string
    end,
    lrem = function(key: string, count: number, value: string): number
        return redis.call("LREM", key, count, value)
    end,
    lset = function(key: string, index: number, value: string): string
        return redis.call("LSET", key, index, value)
    end,
    ltrim = function(key: string, start: number, stop: number): string
        return redis.call("LTRIM", key, start, stop)
    end,

    -- Hash Commands
    hset = function(key: string, field: string, value: string | number): number
        return redis.call("HSET", key, field, tostring(value))
    end,
    hget = function(key: string, field: string): string?
        local result = redis.call("HGET", key, field)
        if result == false then return nil end
        return result :: string
    end,
    hmget = function(key: string, ...: string): { string | boolean }
        return redis.call("HMGET", key, ...)
    end,
    hdel = function(key: string, ...: string): number
        return redis.call("HDEL", key, ...)
    end,
    hexists = function(key: string, field: string): boolean
        return redis.call("HEXISTS", key, field) == 1
    end,
    hgetall = function(key: string): { string }
        -- Redis returns list key1, val1, key2, val2...
        return redis.call("HGETALL", key)
    end,
    hkeys = function(key: string): { string }
        return redis.call("HKEYS", key)
    end,
    hvals = function(key: string): { string }
        return redis.call("HVALS", key)
    end,
    hlen = function(key: string): number
        return redis.call("HLEN", key)
    end,
    hincrby = function(key: string, field: string, increment: number): number
        return redis.call("HINCRBY", key, field, increment)
    end,

    -- Set Commands
    sadd = function(key: string, ...: string | number): number
        return redis.call("SADD", key, ...)
    end,
    srem = function(key: string, ...: string | number): number
        return redis.call("SREM", key, ...)
    end,
    smembers = function(key: string): { string }
        return redis.call("SMEMBERS", key)
    end,
    sismember = function(key: string, member: string | number): boolean
        return redis.call("SISMEMBER", key, member) == 1
    end,
    scard = function(key: string): number
        return redis.call("SCARD", key)
    end,
    spop = function(key: string, count: number?): string | { string } | nil
        if count then
             local result = redis.call("SPOP", key, count)
             if result == false then return nil end
             return result
        else
             local result = redis.call("SPOP", key)
             if result == false then return nil end
             return result :: string
        end
    end,
    srandmember = function(key: string, count: number?): string | { string } | nil
        return redis.call("SRANDMEMBER", key, count)
    end,

    -- Sorted Set Commands
    zadd = function(key: string, ...: string | number): number
        -- Usage: zadd(key, score1, member1, score2, member2, ...)
        return redis.call("ZADD", key, ...)
    end,
    zrem = function(key: string, ...: string | number): number
        return redis.call("ZREM", key, ...)
    end,
    zscore = function(key: string, member: string | number): number?
        local result = redis.call("ZSCORE", key, member)
        if result == false then return nil end
        return tonumber(result)
    end,
    zincrby = function(key: string, increment: number, member: string | number): number
        return tonumber(redis.call("ZINCRBY", key, increment, member))
    end,
    zcard = function(key: string): number
        return redis.call("ZCARD", key)
    end,
    zrange = function(key: string, start: number, stop: number, withscores: boolean?): { string }
        if withscores then
             return redis.call("ZRANGE", key, start, stop, "WITHSCORES")
        else
             return redis.call("ZRANGE", key, start, stop)
        end
    end,
    zrevrange = function(key: string, start: number, stop: number, withscores: boolean?): { string }
        if withscores then
             return redis.call("ZREVRANGE", key, start, stop, "WITHSCORES")
        else
             return redis.call("ZREVRANGE", key, start, stop)
        end
    end,
    zrank = function(key: string, member: string | number): number?
        local result = redis.call("ZRANK", key, member)
        if result == false then return nil end
        return result
    end,
    zrevrank = function(key: string, member: string | number): number?
        local result = redis.call("ZREVRANK", key, member)
        if result == false then return nil end
        return result
    end,
    zcount = function(key: string, min: number | string, max: number | string): number
        return redis.call("ZCOUNT", key, min, max)
    end,
}
