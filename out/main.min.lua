local __DARKLUA_BUNDLE_MODULES={cache={}}do do local function __modImpl()return{
TYPE_STRING="string",
TYPE_LIST="list",
TYPE_SET="set",
TYPE_ZSET="zset",
TYPE_HASH="hash",
TYPE_STREAM="stream",
TYPE_NONE="none",
get=function(key)
local result=redis.call("GET",key)
if result==false then
return nil
end
return result
end,
set=function(key,value)
return redis.call("SET",key,tostring(value))
end,
setnx=function(key,value)
return redis.call("SETNX",key,tostring(value))==1
end,
append=function(key,value)
return redis.call("APPEND",key,value)
end,
strlen=function(key)
return redis.call("STRLEN",key)
end,
getrange=function(key,start,stop)
return redis.call("GETRANGE",key,start,stop)
end,
setrange=function(key,offset,value)
return redis.call("SETRANGE",key,offset,value)
end,
mget=function(keys)
return redis.call("MGET",unpack(keys))
end,
mset=function(input)
local args={}
for k,v in pairs(input)do
table.insert(args,k)
table.insert(args,tostring(v))
end
return redis.call("MSET",unpack(args))
end,

del=function(key)
return redis.call("DEL",key)
end,
exists=function(key)
return redis.call("EXISTS",key)==1
end,
incr=function(key)
return redis.call("INCR",key)
end,
decr=function(key)
return redis.call("DECR",key)
end,
expire=function(key,seconds)
return redis.call("EXPIRE",key,seconds)==1
end,
ttl=function(key)
return redis.call("TTL",key)
end,
copy=function(source,destination)
return redis.call("COPY",source,destination)
end,
type=function(key)
return redis.call("TYPE",key)
end,


lpush=function(key,...)
return redis.call("LPUSH",key,...)
end,
rpush=function(key,...)
return redis.call("RPUSH",key,...)
end,
lpop=function(key,count)
if count then
local result=redis.call("LPOP",key,count)
if result==false then return nil end
return result
else
local result=redis.call("LPOP",key)
if result==false then return nil end
return result
end
end,
rpop=function(key,count)
if count then
local result=redis.call("RPOP",key,count)
if result==false then return nil end
return result
else
local result=redis.call("RPOP",key)
if result==false then return nil end
return result
end
end,
llen=function(key)
return redis.call("LLEN",key)
end,
lrange=function(key,start,stop)
return redis.call("LRANGE",key,start,stop)
end,
lindex=function(key,index)
local result=redis.call("LINDEX",key,index)
if result==false then return nil end
return result
end,
lrem=function(key,count,value)
return redis.call("LREM",key,count,value)
end,
lset=function(key,index,value)
return redis.call("LSET",key,index,value)
end,
ltrim=function(key,start,stop)
return redis.call("LTRIM",key,start,stop)
end,


hset=function(key,field,value)
return redis.call("HSET",key,field,tostring(value))
end,
hget=function(key,field)
local result=redis.call("HGET",key,field)
if result==false then return nil end
return result
end,
hmget=function(key,...)
return redis.call("HMGET",key,...)
end,
hdel=function(key,...)
return redis.call("HDEL",key,...)
end,
hexists=function(key,field)
return redis.call("HEXISTS",key,field)==1
end,
hgetall=function(key)

return redis.call("HGETALL",key)
end,
hkeys=function(key)
return redis.call("HKEYS",key)
end,
hvals=function(key)
return redis.call("HVALS",key)
end,
hlen=function(key)
return redis.call("HLEN",key)
end,
hincrby=function(key,field,increment)
return redis.call("HINCRBY",key,field,increment)
end,


sadd=function(key,...)
return redis.call("SADD",key,...)
end,
srem=function(key,...)
return redis.call("SREM",key,...)
end,
smembers=function(key)
return redis.call("SMEMBERS",key)
end,
sismember=function(key,member)
return redis.call("SISMEMBER",key,member)==1
end,
scard=function(key)
return redis.call("SCARD",key)
end,
spop=function(key,count)
if count then
local result=redis.call("SPOP",key,count)
if result==false then return nil end
return result
else
local result=redis.call("SPOP",key)
if result==false then return nil end
return result
end
end,
srandmember=function(key,count)
return redis.call("SRANDMEMBER",key,count)
end,


zadd=function(key,...)

return redis.call("ZADD",key,...)
end,
zrem=function(key,...)
return redis.call("ZREM",key,...)
end,
zscore=function(key,member)
local result=redis.call("ZSCORE",key,member)
if result==false then return nil end
return tonumber(result)
end,
zincrby=function(key,increment,member)
return tonumber(redis.call("ZINCRBY",key,increment,member))
end,
zcard=function(key)
return redis.call("ZCARD",key)
end,
zrange=function(key,start,stop,withscores)
if withscores then
return redis.call("ZRANGE",key,start,stop,"WITHSCORES")
else
return redis.call("ZRANGE",key,start,stop)
end
end,
zrevrange=function(key,start,stop,withscores)
if withscores then
return redis.call("ZREVRANGE",key,start,stop,"WITHSCORES")
else
return redis.call("ZREVRANGE",key,start,stop)
end
end,
zrank=function(key,member)
local result=redis.call("ZRANK",key,member)
if result==false then return nil end
return result
end,
zrevrank=function(key,member)
local result=redis.call("ZREVRANK",key,member)
if result==false then return nil end
return result
end,
zcount=function(key,min,max)
return redis.call("ZCOUNT",key,min,max)
end,
}end function __DARKLUA_BUNDLE_MODULES.a()local v=__DARKLUA_BUNDLE_MODULES.cache.a if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.a=v end return v.c end end end

local redis=__DARKLUA_BUNDLE_MODULES.a()

redis.mset({
name="Alice",
age=30,
city="Wonderland"
})

return nil