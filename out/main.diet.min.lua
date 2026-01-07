local __DARKLUA_BUNDLE_MODULES={cache={}}do do local function __modImpl()return{
mset=function(input)local args={}for k,v in pairs(input)do table.insert(args,k)
table.insert(args,tostring(v))end return redis.call('MSET',unpack(args))end}end
function __DARKLUA_BUNDLE_MODULES.a()local v=__DARKLUA_BUNDLE_MODULES.cache.a if
not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.a=v end return v.c
end end end local redis=__DARKLUA_BUNDLE_MODULES.a()redis.mset({name='Alice',age
=30,city='Wonderland'})return nil