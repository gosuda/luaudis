local __DARKLUA_BUNDLE_MODULES={cache={}}do do local function __modImpl()return{
get=function(key)local result=redis.call('GET',key)if result==false then return
nil end return result end,set=function(key,value)return redis.call('SET',key,
tostring(value))end,del=function(key)return redis.call('DEL',key)end,exists=
function(key)return redis.call('EXISTS',key)==1 end,incr=function(key)return
redis.call('INCR',key)end,decr=function(key)return redis.call('DECR',key)end,
expire=function(key,seconds)return redis.call('EXPIRE',key,seconds)==1 end,ttl=
function(key)return redis.call('TTL',key)end,copy=function(source,destination)
return redis.call('COPY',source,destination)end,type=function(key)return redis.
call('TYPE',key)end}end function __DARKLUA_BUNDLE_MODULES.a()local v=
__DARKLUA_BUNDLE_MODULES.cache.a if not v then v={c=__modImpl()}
__DARKLUA_BUNDLE_MODULES.cache.a=v end return v.c end end end local redis=
__DARKLUA_BUNDLE_MODULES.a()return redis.type('b')