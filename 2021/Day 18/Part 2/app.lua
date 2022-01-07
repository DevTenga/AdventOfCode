-- Advent of Code: Day 18,Part 2
-- DevTenga
-- 18/12/2021

-- https://adventofcode.com/2021/day/18


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

function table_deepCopy(t)
	local _t = {}

	for k,v in next,t do
		if type(v) ~= "table" then
			_t[k] = v
		else
			_t[k] = table_deepCopy(v)
		end
	end
	return _t
end

function table_deepLinearPrint(t, _isRecursive)
	if not t then return end
	local _str = "["
	
	for _,v in next,t do
		_str = _str .. (type(v) ~= "table" and v or table_deepLinearPrint(v, true))..","
	end

	_str = string.sub(_str,1,#_str - 1).."]"
	if not _isRecursive then print(_str) else return _str end
end


-- ========================== Math Utilities ========================== --
function math_get_max3_idx(t)
	local max1,max2,max3 = 0,0,0
	local imax1,imax2,imax3 = 0,0,0

	for idx,val in ipairs(t) do
		if val >= max1 then
			max3 = max2
			max2 = max1
			max1 = val

			imax3 = imax2
			imax2 = imax1
			imax1 = idx
		elseif val >= max2 then
			max3 = max2
			max2 = val

			imax3 = imax2
			imax2 = idx
		elseif val >= max3 then
			max3 = val
			imax3 = idx
		end
	end

	return imax1, imax2, imax3, max1, max2, max3
end

-- ========================== Core Functions =========================== --

-- Converts a string snail number to a table.
local function parse_snailNum(snailNum)
	-- Remove the outermost brackets.
	snailNum = string.sub(snailNum,2,#snailNum - 1)

	local container = {}

	-- Whether it has an inner pair, or just numbers.
	-- If it does, when to stop collecting the string.
	local isInHierarchy = false
	local hierarchyCount = 0

	-- The position of the new element in {container}.
	-- It is lighter to just add it when needed rather
	-- than getting the size of {container} every time.
	local idx = 1 

	-- The string that is passed to maybe the inner recursion
	-- for parsing.
	local currentStr = ""

	for char in string.gmatch(snailNum,"(.)") do
		
		if tonumber(char) and not isInHierarchy then
			container[idx] = tonumber(char)
			idx = idx + 1
			currentStr = ""
		elseif char == "[" then
			isInHierarchy = true
			hierarchyCount = hierarchyCount + 1
			currentStr = currentStr .. char
		elseif char == "]" and hierarchyCount == 1 then
			isInHierarchy = false
			hierarchyCount = 0
			container[idx] = parse_snailNum(currentStr .. "]")
			idx = idx + 1
			currentStr = ""
		elseif char == "]" then
			hierarchyCount = hierarchyCount - 1
			currentStr = currentStr.."]"
		elseif isInHierarchy or char ~= "," then
			currentStr = currentStr .. char
		end

	end

	return container
end

-- Used to increase the value of the number
-- adjacent to an exploding pair. Uses 
-- recursion to move to the inner pairs.
local function increase_val_at(t, idx, val, checkFront)
	if not t then return end
	local selected = t[idx]
	if type(selected) == "number" then
		t[idx] = selected + val
	else
		increase_val_at(selected, checkFront and 1 or #selected, val, checkFront)
	end
end

-- Explodes a pair. 
local function explode_snailNum(t, tParent, tParentIdx, depth)
	depth = depth or 1 -- Setting a default value for the first time case.

	local foundTable, didExplode, isDeepEnough, addend, pAddend
	
	for i,v in ipairs(t) do
		if type(v) == "table" then
			isDeepEnough, didExplode, addend, pAddend = explode_snailNum(v, t, i, depth + 1)
			foundTable = true -- Found a table. Do not do addition in this depth.

			-- If it is the first element, add to the right.
			if tParentIdx == 1 and addend then
				increase_val_at(tParent,2,addend,true)
				addend = nil
			-- Else, add to the left.
			elseif tParentIdx == 2 and pAddend then
				increase_val_at(tParent,1,pAddend,false)
				pAddend = nil
			end

			-- Deep table. Check for addition now.
			if isDeepEnough then break end
		end
	end

	-- Is the deepest table. Do the addition stuff.
	if not foundTable and depth >= 4 then
		tParent[tParentIdx] = 0
		
		-- If it is the first element, add to the right.
		if tParentIdx == 1 then
			increase_val_at(tParent,2,t[2],true)
			addend = nil
			pAddend = t[1]
		-- Else, add to the left.
		elseif tParentIdx == 2 then
			increase_val_at(tParent,1,t[1],false)
			pAddend = nil
			addend = t[2]
		end

		return true,true,addend, pAddend
	end

	-- Addition criterion not met. Return any computed results.
	return isDeepEnough, didExplode, addend, pAddend
end

-- Splits a large number.
local function split_snailNum(t)
	for i,v in ipairs(t) do
		-- Look deeper. It is a table.
		if type(v) == "table" then
			local didSplit = split_snailNum(v)
			if didSplit then return true end -- Otherwise, continue.
		-- No deeper. If it is large, split it. 
		elseif type(v) == "number" and v >= 10 then
			t[i] = {math.floor(v / 2), math.ceil(v / 2)}
			return true
		end
	end
end

-- This is the main wrapper. It reduces a snail number.
local function reduce_snailNum(snailNum)
	for i,v in ipairs(snailNum) do
		local didExplode,didSplit
		local addend,pAddend = nil, nil
		_, didExplode, addend, pAddend = explode_snailNum(v, snailNum, i, 1)

		-- If it is the first element, add to the right.
		if addend and i == 1 then
			increase_val_at(snailNum,2,addend,true)
		elseif pAddend and i == 2 then
		-- Else, add to the left.
			increase_val_at(snailNum,1,pAddend,false)
		end

		-- Debugging
		--[[print("AT ".. i.. " AFTER EXPLOSION:")
		table_deepLinearPrint(snailNum)]]

		-- If it exploded once, it may do so once again. 
		-- It is safer to check.
		-- Returns to the top of the reduction program flow.
		if didExplode then
			return reduce_snailNum(snailNum)
		end
	
	end

	for i,v in ipairs(snailNum) do
		didSplit = split_snailNum(v)

		-- Debugging
		--[[
		print ("AT "..i.." AFTER SPLIT:")
		table_deepLinearPrint(snailNum)
		print()
		--]]

		-- If it split once, it may do so once again. 
		-- It is safer to check.
		-- Returns to the top of the reduction program flow.
		if didSplit then
			return reduce_snailNum(snailNum)
		end
	end
		
	return snailNum
end


-- Get the magnitude of the snail number.
local function get_snailNum_magnitude(snailNum)
	return 
	type(snailNum) == "number" 
	and snailNum
	or 3 * get_snailNum_magnitude(snailNum[1]) + 2 * get_snailNum_magnitude(snailNum[2])
end

-- Get just the sum of all numbers
local function get_snailNum_sum(snailNum)
	return 
	type(snailNum) == "number" 
	and snailNum
	or get_snailNum_sum(snailNum[1]) + get_snailNum_sum(snailNum[2])
end

-- ============================ Code Flow ============================== --
for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	local snailNums = {}
	local snailMags = {} -- Magnitude of snail-sums

	local mainStr = ""

	-- Collect all the snail numbers in a table.
	local function handle_str()
		local num = parse_snailNum(mainStr)
		snailNums[#snailNums + 1] = num
		mainStr = ""
	end

	for char in string.gmatch(contents,"(.)") do
		if char == "\n" then
			handle_str()
		else
			mainStr = mainStr .. char
		end
	end
	handle_str()

	print("=======================================\nFILE:",file)

	-- Some smaller names for functions.
	local mag = get_snailNum_magnitude
	local copy = table_deepCopy
	local reduce = reduce_snailNum
	local idx = 1

	-- Loop through each element, add in both ways and put in a table.
	for i = 1, #snailNums do
		for j = i + 1, #snailNums do
			snailMags[idx] = mag(reduce {copy(snailNums[i]), copy(snailNums[j]) })
			snailMags[idx + 1] = mag(reduce {copy(snailNums[j]), copy(snailNums[i])})
			idx = idx + 2 -- We used up two slots.
		end
	end

	local answer = math.max(table.unpack(snailMags))

	print("For File:",file,"Answer is:",answer)
end
