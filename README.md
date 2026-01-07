# luaudis

`luaudis` is a library that allows you to write Redis scripts using Luau, a statically typed language that is highly compatible with Lua.

## Features

- **Type Safety**: Write Redis scripts with Luau's type system to catch errors at compile time.
- **Tree Shaking**: Automatically removes unused Redis commands from the final script, keeping the output size small.
- **Reach Redis Command Support**: Includes wrappers for most common Redis commands (String, List, Hash, Set, Sorted Set, etc.).
- **Minification**: Outputs minified Lua scripts ready for production.

## Prerequisites

- [Luau](https://luau-lang.org/) - A fast, safe, gradually typed scripting language derived from Lua.
- [darklua](https://darklua.com/docs/installation/) - A Luau code processor.
- [lune](https://lune-org.github.io/docs/getting-started/1-installation/) - A Luau runtime.
- [Taskfile](https://taskfile.dev/docs/installation) - A task runner for automating development workflows.

## Installation

`luaudis` is designed to be used as a template for your Redis Lua script projects.

1.  Click the **"Use this template"** button on GitHub to create a new repository based on `luaudis`.
2.  Clone your new repository:

    ```bash
    git clone https://github.com/your-username/your-repo-name.git
    cd your-repo-name
    ```

## Usage

### 1. Write your script

Create a Luau file (e.g., `src/main.luau`) and import the redis module:

```luau
local redis = require("./redis")

-- Use Redis commands with type checking
redis.set("mykey", "Hello, Redis!")
local value = redis.get("mykey")

return value
```

### 2. Build the project

Use `task` to build, optimize, and minify your script:

```bash
task build
```

This command performs the following steps:
1.  **Process**: Converts Luau code to Lua 5.1 compatible code using `darklua`.
2.  **Diet**: Analyzes `src/main.luau` and removes unused Redis command wrappers from the output.
3.  **Minify**: Minifies the final Lua script.

The output will be generated at `out/main.diet.min.lua`.

### 3. Run the script

You can execute the built script using `redis-cli`:

```bash
redis-cli --eval out/main.diet.min.lua
```

Or use the provided task:

```bash
task run
```

## Supported Commands

`luaudis` supports a wide range of Redis commands, including:

- **Keys**: `del`, `exists`, `expire`, `ttl`, `type`, `copy`
- **Strings**: `get`, `set`, `setnx`, `append`, `strlen`, `getrange`, `setrange`, `mget`, `mset`, `incr`, `decr`
- **Lists**: `lpush`, `rpush`, `lpop`, `rpop`, `llen`, `lrange`, `lindex`, `lrem`, `lset`, `ltrim`
- **Hashes**: `hset`, `hget`, `hmget`, `hdel`, `hexists`, `hgetall`, `hkeys`, `hvals`, `hlen`, `hincrby`
- **Sets**: `sadd`, `srem`, `smembers`, `sismember`, `scard`, `spop`, `srandmember`
- **Sorted Sets**: `zadd`, `zrem`, `zscore`, `zincrby`, `zcard`, `zrange`, `zrevrange`, `zrank`, `zrevrank`, `zcount`

## License

Apache License 2.0
