local __DARKLUA_BUNDLE_MODULES={cache={}}do do local function __modImpl()return {
    get = function(key)        
return ((redis.call("GET", key) ))
    end,
    set = function(key, value)
        return redis.call("SET", key, value)
    end,
}
end function __DARKLUA_BUNDLE_MODULES.a()local v=__DARKLUA_BUNDLE_MODULES.cache.a if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.a=v end return v.c end end end
local redis = __DARKLUA_BUNDLE_MODULES.a()

return redis.get("a")
