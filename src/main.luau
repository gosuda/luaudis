local redis = require("./redis")

redis.mset({
    name = "Alice",
    age = 30,
    city = "Wonderland"
})

return nil