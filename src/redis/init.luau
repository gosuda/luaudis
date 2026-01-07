return {
    get = function(key: string): string
        return (redis.call("GET", key) :: string)
    end,
    set = function(key: string, value: string)
        return redis.call("SET", key, value)
    end,
}
