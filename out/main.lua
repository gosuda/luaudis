local a=require"./src/add"

local b=0
b+=10

local c=`Count is {a.add(b,100)}`

if b>5 then
print(c)
end