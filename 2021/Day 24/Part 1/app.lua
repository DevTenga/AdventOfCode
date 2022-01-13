-- Advent of Code: Day 24,Part 1
-- DevTenga
-- 12/01/2022

-- https://adventofcode.com/2021/day/24

-- ========================== Table Utilities ========================== --

function table_deepPrint(t,tabCount,_isRecursive)
	tabCount = tabCount or 0
	if not _isRecursive then print(string.rep("\t",tabCount).."{") end
	for k,v in next,t do
		if type(v) ~= "table" then
			print(string.rep("\t",tabCount + 1)..'['..k..'] = '..v..",")
		else
			print(string.rep("\t",tabCount + 1)..'['..k..'] = {')
			table_deepPrint(v,tabCount + 1,true)
		end
	end
	print(string.rep("\t",tabCount).."}")
	if not _isRecursive then print("\n\n======================\n\n") end
end

function table_find(t,v)
	for idx = 0, #t do
		val = t[idx]
		if v == val then return idx end
	end
end

function table_deepLinearPrint(t, _isRecursive)
	if not t then return end
	local _str = "["
	
	for _,v in next,t do
		_str = _str .. (type(v) ~= "table" and v or table_deepLinearPrint(v, true))..","
	end

	_str = string.sub(_str,1,#_str - 1).."]"
	if _str == "]" then _str = "[]" end 
	if not _isRecursive then print(_str) else return _str end
end



-- ============================ Code Flow ============================== --


for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	local chunks = {}
	local idx,innerIdx = 0,1

	local ALUmtt = {}
	ALUmtt.__index = ALUmtt

	function ALUmtt:inp(var, val)
		self[var] = val
	end 

	function ALUmtt:add(var,val)
		self[var] = self[var] + val
	end

	function ALUmtt:mul(var,val)
		self[var] = self[var] * val
	end

	function ALUmtt:div(var,val)
		assert(val ~= 0, "\027[31mAttempt to divide by 0.\027[0m")
		self[var] = math.floor(self[var] / val)
	end

	function ALUmtt:mod(var,val)
		assert(self[var] >= 0, "\027[31mCannot mod on a negative number.\027[0m")
		assert(val > 0, "\027[31mAttempting to mod by 0 or negative number.\027[0m")
		self[var] = self[var] % val
	end

	function ALUmtt:eql(var,val)
		self[var] = self[var] == val and 1 or 0
	end

	function ALUmtt:new(w, x, y, z)
		return setmetatable({w = w or 0, x = x or 0, y = y or 0, z = z or 0},self)
	end

	local function run_chunk(chunkIdx, stdin, ALU)
		local chunk = chunks[chunkIdx]
		for _,instr in ipairs(chunk) do
			local val 
			
			if instr.cmd == "inp" then
				val = stdin
			else
				val = ALU[instr.val] or tonumber(instr.val)
			end
			ALU[instr.cmd](ALU, instr.var, val)
		end
		return ALU
	end

	for cmd, var, val in string.gmatch(contents,"(%w+) (%w)%s*([%w%d%-]*)[\n]") do
		if cmd == "inp" then
			innerIdx = 1
			idx = idx + 1
			chunks[idx] = {}
		end
		if val == '' then val = nil end

		chunks[idx][innerIdx] = {cmd = cmd, var = var, val = val}
		innerIdx = innerIdx + 1
	end

	-- Matching the last.
	local cmd, var, val = string.match(contents, "(%w+) (%w)%s*([%w%d%-]*)$")
	chunks[idx][innerIdx] = {cmd = cmd, var = var, val = val}

	local function f(str)
		return string.format("%1d",str)
	end

	--table_deepPrint(chunks)

	-- For: Binary Value
	--[[
	local res = run_chunk(1,13,ALUmtt:new())

	print("Binary Value is:"..f(res.w)..f(res.x)..f(res.y)..f(res.z))
	]]

	-- For: Thrice Number
	--[[
	local res = run_chunk(1,33,ALUmtt:new())
	res = run_chunk(2,9)
	print("Did match:",f(res.z))
	]]

	-- For: MONAD

	local largest = 0
	local numbers = {}
	local sums = {}

	local function test_MONAD(digitPlace, zCompat, digits)
		print("At:", digitPlace, table_deepLinearPrint(zCompat, true), table_deepLinearPrint(digits, true))
		local chunkIdx = 14 - digitPlace + 1
		local chunk = chunks[chunkIdx]
		
		for digit = 9, 1, -1 do
			
			if digitPlace == 14 then
				if digit >= largest then
					print("IN FINAL YESSS")
					local res = run_chunk(1, digit, ALUmtt:new())
					if table_find(zCompat, res.z) then
						numbers[#numbers + 1] = {digit, table.unpack(digits)}
						largest = digit
					end
				end
			else

				local nextZCompat = {}
				for z = 0, 26 do
					local res = run_chunk(chunkIdx, digit, ALUmtt:new(0,0,0,z))
					if table_find(zCompat, res.z) then
						print(digitPlace..": ***** Passed test for: "..digit.."; "..z.." Got:"..res.z.." *****")
						nextZCompat[#nextZCompat + 1] = z
					else
						--print("\027[31m Failed test for:"..res.z.."\027[0m")
						print(digitPlace..": * Failed test for: "..digit.."; "..z.." Got:"..res.z.." *")
					end
				end

				if next(nextZCompat) then
					test_MONAD(digitPlace + 1, 
						nextZCompat, 
						{digit, table.unpack(digits)}
						)
				end
			end

		end
	end

	test_MONAD(1, {0}, {})

	print(#numbers)

	for _, number in ipairs(numbers) do
		if number[1] == largest then
			local sum = number[1] * 10^14
			
			local len = #number[2]
			for idx,digit in ipairs(number[2]) do
				sum = sum + digit * 10 ^ (len - idx + 1)
			end

			sums[#sums + 1] = sum
		end
	end

	local answer = math.max(table.unpack(sums))

	print("For File:",file,"Answer is:",answer)
end
