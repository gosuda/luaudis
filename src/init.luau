local add = require("./src/add")

local count = 0
count += 10 -- compound assign

local msg = `Count is {add.add(count, 100)}` -- interpolated string

if count > 5 then
    print(msg)
end