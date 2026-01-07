local add = require("./src/add")

local count = 0
count =count+ 10 

local msg = string.format('Count is %s', tostring(add.add(count, 100)))

if count > 5 then
    print(msg)
end
