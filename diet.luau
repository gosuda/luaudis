local fs = require("@lune/fs")
local stdio = require("@lune/stdio")
local process = require("@lune/process")

local function main()
	local inputPath = "out/main.lua"
	local outputPath = "out/main.diet.lua"

	if not fs.isFile(inputPath) then
		stdio.ewrite("Input file not found: " .. inputPath .. "\n")
		process.exit(1)
	end

	local content = fs.readFile(inputPath)

	-- 1. redis 변수명 찾기
	-- 우선순위 1: 모듈 호출 형태 (local redis = __DARKLUA... .a())
	local redisVar = string.match(content, "local%s+([%w_]+)%s*=%s*__DARKLUA_BUNDLE_MODULES%.[%w_]+%(%)")
	
	-- 우선순위 2: 일반 할당 형태
	if not redisVar then
		redisVar = string.match(content, "local%s+([%w_]+)%s*=%s*__DARKLUA_BUNDLE_MODULES")
	end

	-- 우선순위 3: 기본값
	if not redisVar then
		redisVar = "redis"
		print("Warning: Could not detect Redis variable name. Using default: " .. redisVar)
	end

	print("Detected Redis variable name: " .. redisVar)

	-- 2. 사용된 메서드 찾기
    local usedMethods = {}
    -- 메서드 호출 탐지 (함수 호출 형태, 테이블 호출 형태 등을 포괄적으로 검사)
    -- 예: redis.mset(...) or redis.mset{...} or redis.type"..." 
    -- 정규식: redisVar (공백) . (공백) (메서드명)
    for method in string.gmatch(content, redisVar .. "%s*%.%s*([%w_]+)") do
        usedMethods[method] = true
    end
    -- 인덱싱 형태 탐지
    -- 예: redis["mset"]
    for method in string.gmatch(content, redisVar .. '%s*%["([%w_]+)"%]') do
        usedMethods[method] = true
    end
    for method in string.gmatch(content, redisVar .. "%s*%['([%w_]+)'%]") do
        usedMethods[method] = true
    end

	-- 관리할 키 목록
	local knownKeys = {
		"TYPE_STRING", "TYPE_LIST", "TYPE_SET", "TYPE_ZSET", "TYPE_HASH", "TYPE_STREAM", "TYPE_NONE",
		"get", "set", "setnx", "append", "strlen", "getrange", "setrange", "mget", "mset",
		"del", "exists", "incr", "decr", "expire", "ttl", "copy", "type",
		"lpush", "rpush", "lpop", "rpop", "llen", "lrange", "lindex", "lrem", "lset", "ltrim",
		"hset", "hget", "hmget", "hdel", "hexists", "hgetall", "hkeys", "hvals", "hlen", "hincrby",
		"sadd", "srem", "smembers", "sismember", "scard", "spop", "srandmember",
		"zadd", "zrem", "zscore", "zincrby", "zcard", "zrange", "zrevrange", "zrank", "zrevrank", "zcount",
	}

	local newContent = content
    local removedCount = 0

    -- 간단한 파서 함수: 특정 위치부터 Function Body의 끝(end)을 찾음
    local function findFunctionEnd(str, startIndex)
        local len = #str
        local p = startIndex
        local balance = 0 
        
        while p <= len do
            -- 문자열/주석 스킵 로직 (간단 구현)
            local char = string.sub(str, p, p)
            
            -- 문자열 ("..." or '...')
            if char == '"' or char == "'" then
                 local quote = char
                 p = p + 1
                 while p <= len do
                     local c = string.sub(str, p, p)
                     if c == "\\" then
                         p = p + 2 
                     elseif c == quote then
                         break 
                     else
                         p = p + 1
                     end
                 end
            else
                -- 키워드 체크
                local function check(word)
                    if string.sub(str, p, p + #word - 1) == word then
                        local nextChar = string.sub(str, p + #word, p + #word)
                        if string.find(nextChar, "[^%w_]") or nextChar == "" then
                            return true
                        end
                    end
                    return false
                end

                if check("function") then
                    balance = balance + 1
                    p = p + 7 -- length of 'function' - 1 (loop adds 1)
                elseif check("if") then
                    balance = balance + 1
                    p = p + 1 
                elseif check("do") then
                    -- for ... do, while ... do, do ... end
                    balance = balance + 1
                    p = p + 1
                elseif check("repeat") then
                     -- repeat ... until 구조는 end를 쓰지 않으므로 balance에 영향 X
                elseif check("end") then
                    balance = balance - 1
                    p = p + 2
                    if balance == 0 then
                        return p -- Found the closing end
                    end
                end
            end
            p = p + 1
        end
        return nil
    end

	for _, key in ipairs(knownKeys) do
		if not usedMethods[key] then
			-- Case 1: 상수 (key="val",)
            local constPattern = key .. '="[^"]-",?'
            local from, to = string.find(newContent, constPattern)
            if from then
                newContent = string.sub(newContent, 1, from - 1) .. string.sub(newContent, to + 1)
                print("Removed constant: " .. key)
                removedCount = removedCount + 1
            else
                -- Case 2: 함수 (key=function)
                -- 1. "key=function" 문자열 찾기
                local keyFuncStr = key .. "=function"
                local keyFuncStart = string.find(newContent, keyFuncStr, 1, true)
                
                if keyFuncStart then
                    -- 2. function 키워드 뒤의 end 찾기
                    local funcKeywordPos = keyFuncStart + #key + 1
                    local endPos = findFunctionEnd(newContent, funcKeywordPos)
                    
                    if endPos then
                        -- 3. 제거 범위 확장: 뒤따르는 콤마/공백 제거
                        local removeEnd = endPos
                        local nextPart = string.sub(newContent, removeEnd + 1)
                        local _, commaEnd = string.find(nextPart, "^%s*,%s*")
                        if commaEnd then
                            removeEnd = removeEnd + commaEnd
                        end
                        
                        -- 실제 제거
                        newContent = string.sub(newContent, 1, keyFuncStart - 1) .. string.sub(newContent, removeEnd + 1)
                        
                        print("Removed function: " .. key)
                        removedCount = removedCount + 1
                    else
                        print("Error: Could not find function end for " .. key)
                    end
                end
            end
		end
	end

	fs.writeFile(outputPath, newContent)
	print("Done. Removed " .. removedCount .. " items. Saved to " .. outputPath)
end

main()
