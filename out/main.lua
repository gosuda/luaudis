local __DARKLUA_BUNDLE_MODULES={cache={}}do do local function __modImpl()
return {
    add = function(x, y)        
return x + y
    end,
}
end function __DARKLUA_BUNDLE_MODULES.a()local v=__DARKLUA_BUNDLE_MODULES.cache.a if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.a=v end return v.c end end end
local add = __DARKLUA_BUNDLE_MODULES.a()

local count = 0
count =count+ 10 

local msg = string.format('Count is %s', tostring(add.add(count, 100)))

if count > 5 then
    print(msg)
end