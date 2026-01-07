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
	-- 메서드 호출 패턴 (점 표기법, 공백 유연성 추가)
	for method in string.gmatch(content, redisVar .. "%s*%.%s*([%w_]+)") do
		usedMethods[method] = true
	end
    -- 메서드 호출 패턴 (문자열 인덱싱) e.g. redis["get"] - darklua에 의해 변환될 수 있음
    for method in string.gmatch(content, redisVar .. '%["([%w_]+)"%]') do
        usedMethods[method] = true
    end
    for method in string.gmatch(content, redisVar .. "%['([%w_]+)'%]") do
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

	for _, key in ipairs(knownKeys) do
		if not usedMethods[key] then
			-- Case 1: 상수 (key="val",)
            -- 정규식: key="[^"]-",?
            -- 주의: 다른 곳 매칭 방지 위해 최대한 안전하게
            local constPattern = key .. '="[^"]-",?'
            local startConst = string.find(newContent, constPattern)
            if startConst then
                newContent = string.gsub(newContent, constPattern, "")
                print("Removed constant: " .. key)
                removedCount = removedCount + 1
            else
                -- Case 2: 함수 (key=function)
                local keyFuncStart = string.find(newContent, key .. "=function", 1, true)
                if keyFuncStart then
                    local len = #newContent
                    local removeEnd = 0
                    local balance = 0
                    local p = keyFuncStart
                    
                    -- 간단한 파서
                    while p <= len do
                        -- 문자열 스킵
                        local char = string.sub(newContent, p, p)
                        if char == '"' or char == "'" then
                             local quote = char
                             p = p + 1
                             while p <= len do
                                 local c = string.sub(newContent, p, p)
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
                            -- function, if, do 는 balance 증가
                            -- end 는 balance 감소
                            -- 단어 경계 체크 필요. generated code는 공백 없을 수 있음.
                            
                            local function checkKeyword(word)
                                if string.sub(newContent, p, p + #word - 1) == word then
                                    local nextChar = string.sub(newContent, p + #word, p + #word)
                                    if string.find(nextChar, "[^%w_]") or nextChar == "" then
                                        return true
                                    end
                                end
                                return false
                            end

                            if checkKeyword("function") then
                                balance = balance + 1
                                p = p + 7 -- skip
                            elseif checkKeyword("if") then
                                balance = balance + 1
                                p = p + 1
                            elseif checkKeyword("do") then
                                balance = balance + 1
                                p = p + 1
                            elseif checkKeyword("end") then
                                balance = balance - 1
                                p = p + 2 -- 'end' is 3 chars, loop adds 1
                                if balance == 0 then
                                    -- Found the closing end of the function
                                    if string.sub(newContent, p + 1, p + 1) == "," then
                                        p = p + 1
                                    end
                                    removeEnd = p
                                    break
                                end
                            end
                        end
                        p = p + 1
                    end
                    
                    if removeEnd > 0 then
                        newContent = string.sub(newContent, 1, keyFuncStart - 1) .. string.sub(newContent, removeEnd + 1)
                        print("Removed function: " .. key)
                        removedCount = removedCount + 1
                    end
                end
            end
		end
	end

	fs.writeFile(outputPath, newContent)
	print("Done. Removed " .. removedCount .. " items. Saved to " .. outputPath)
end

main()
