-- Advent of Code: Day 8,Part 2
-- DevTenga
-- 08/12/2021

-- https://adventofcode.com/2021/day/8

local function table_find(t,v)
	for idx = 0, #t do
		val = t[idx]
		if v == val then return idx end
	end
end

local function string_sort(str)
	local t = {}
	local newStr = ""

	for i = 1,#str do
		t[i] = string.sub(str,i,i)
	end

	table.sort(t,function(a,b)
		if string.byte(a) < string.byte(b) then 
			return true 
		else 
			return false 
		end
	end)

	for _,char in ipairs(t) do
		newStr = newStr..char
	end
	return newStr 
end

local function string_common( ... )
	local args = {...}

	local pattern = "["..args[1].."]"
	local final = ""

	for i = 2, #args do
		local result = ""
		for element in string.gmatch(args[i],pattern) do
			result = result .. element
		end
		final = result
		pattern = "["..result.."]"
	end
	return final
end

local function string_uncommon(str, pattern)
	local pattern = "["..pattern.."]"
	local result = ""
	for i = 1,#str do
		local char = string.sub(str,i,i)
		if not string.match(char,pattern) then
			result = result .. char
		end 
	end
	if result == "" then return nil end
	return result
end

for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	local signalSize = {
		[0] = 6,
		[1] = 2,
		[2] = 5,
		[3] = 5,
		[4] = 4,
		[5] = 5,
		[6] = 6,
		[7] = 3,
		[8] = 7,
		[9] = 6 
	}

	local lineCounter = 0
	local answer = 0

	for patterns,outputs in string.gmatch(contents,"([%w ]+) *| *\n*([%w ]+)") do
		lineCounter = lineCounter + 1

		local SimSignal = {
			five = {},
			six = {}
		}

		local charMap = {}
		local charMapInv = {}

		for pattern in string.gmatch(patterns,"(%w+)") do
			pattern = string_sort(pattern)
			local find = table_find(signalSize,#pattern)
			
			if find and table_find({1,4,7,8},find) then 
				charMap[pattern] = find
				charMapInv[find] = pattern
			elseif #pattern == 5 then
				SimSignal.five[#SimSignal.five + 1] = pattern
			elseif #pattern == 6 then
				SimSignal.six[#SimSignal.six + 1] = pattern
			end
		end

		-- Locating 0, 9 and 6:
		local vertical = string_common(table.unpack(SimSignal.five))

		for idx,input in ipairs(SimSignal.six) do
			local line = string_uncommon(vertical,input)
			if line and #line == 1 then
				charMap[input] = '0'
				charMapInv[0] = input
			elseif not string_uncommon(charMapInv[4],input) then
				charMap[input] = "9"
				charMapInv[9] = input
			else
				charMap[input] = "6"
				charMapInv[6] = input
			end

		end

		-- Locating 3, 5 and 2:
		for idx,input in ipairs(SimSignal.five) do
			if 
				not string_uncommon(input,charMapInv[9]) 
				and not string_uncommon(input,charMapInv[6]) 
			then
				charMap[input] = "5"
				charMapInv[5] = input
			elseif not string_uncommon(input,charMapInv[9]) then
				charMap[input] = "3"
				charMapInv[3] = input
			else
				charMap[input] = "2"
				charMapInv[2] = input
			end
		end


		local val = ""
		
		for output in string.gmatch(outputs,"(%w+)") do
			output = string_sort(output)
			val = val .. charMap[output]
		end

		print("FOR LINE:",lineCounter,"VAL IS",val)
		answer = answer + tonumber(val)
	end
	print("For File:",file,"Answer is:",answer)
end
