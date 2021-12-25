-- Advent of Code: Day 18,Part 1
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


-- ========================== Core Functions =========================== --

function increase_val_at(t, idx, val, isFront)
	if not t then return end
	local selected = t[idx]
	if type(selected) == "number" then
		t[idx] = selected + val
	else
		increase_val_at(selected, isFront and 1 or #selected, val, isFront)
	end
end

function find_first_right_element()
	
end



function explode_num(indices, t, tParent, tParentIdx, tPrev, tPrevIdx, tNext, tNextIdx, depth, selIdx)
	depth = depth or 1

	local foundTable, didExplode, isDeepEnough, addend
	
	for i,v in ipairs(t) do
		local currentIndices = table_deepCopy(indices)
		currentIndices[#currentIndices + 1] = i

		if type(v) == "table" then
			
			tPrev = t[i - 1] and t or tPrev
			tNext = t[i + 1] and t or tNext
			tPrevIdx = t[i - 1] and i - 1 or tPrevIdx
			tNextIdx = t[i + 1] and i + 1 or tNextIdx

			isDeepEnough, didExplode, addend = explode_num(currentIndices, v, t, i, tPrev, tPrevIdx, tNext, tNextIdx, depth + 1)
			foundTable = true

			if tParentIdx == 1 and addend then
				increase_val_at(tParent,2,addend,true)
				addend = nil
			end
			if isDeepEnough then break end
		end

	end

	if not foundTable and depth >= 4 then
	--[[	print 'PARAMS:'
		table_deepLinearPrint(tPrev)
		table_deepLinearPrint(tNext)
		print(tPrevIdx)
		print(tNextIdx)
		print()
--]]
		increase_val_at(tPrev, tPrevIdx ,t[1],false)
		tParent[tParentIdx] = 0
		
		if tParentIdx == 1 then
			increase_val_at(tParent,2,t[2],true)
			addend = nil
		else
			addend = t[2]
		end

		return true,true,addend
	end

	return isDeepEnough, didExplode, addend

end


function split_num(t)
	
	for i,v in ipairs(t) do
		if type(v) == "table" then
			local didSplit = split_num(v)
			if didSplit then return true end
		elseif type(v) == "number" and v >= 10 then
			t[i] = {math.floor(v / 2), math.ceil(v / 2)}
			return true
		end
	end

end

for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	local snailNums = {}

	local function parse_snailNum(snailNum)
		snailNum = string.sub(snailNum,2,#snailNum - 1)
		local container = {}

		local isInHierarchy = false
		local hierarchyCount = 0
		local idx = 1
		local currentStr = ""

		for i = 1, #snailNum do
			local char = string.sub(snailNum,i,i)
			
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

	local function reduce_snail_num(snailNum)
		for i,v in ipairs(snailNum) do
			local didExplode,didSplit,addend 
			repeat 
				_, didExplode,addend = explode_num({i},v)

				if addend and i == 1 then
					increase_val_at(snailNum,2,addend,true)
				end

				-- Debugging
				--[[print("AT ".. i.. " AFTER EXPLOSION:")
				table_deepLinearPrint(snailNum)
				print ("AT "..i.." AFTER SPLIT:")--]]
				
				didSplit = split_num(v)
				--table_deepLinearPrint(snailNum)

				--print("\nSHOULD GO NEXT?", not didExplode, not didSplit,"\n\n")
				
			until not didExplode and not didSplit
		end

		return snailNum, indices
	end

	local mainStr = ""

	local function handle_str()
		--print(mainStr)
		local num = parse_snailNum(mainStr)
		snailNums[#snailNums + 1] = num
		mainStr = ""
		--table_deepPrint(num)
	end

	for char in string.gmatch(contents,"(.)") do
		if char == "\n" then
			handle_str()
		else
			mainStr = mainStr .. char
		end
	end
	handle_str()

	local snailSum

	--table_deepPrint(snailNums)

	-- DO NOT DELETE
	for i = 1, #snailNums - 1 do
		local currentNum,nextNum = snailSum or snailNums[1], snailNums[i + 1]
		snailSum = {table_deepCopy(currentNum),table_deepCopy(nextNum)}
		--[[print("AFTER ADDITION:")
		table_deepLinearPrint(snailSum)--]]
		snailSum = reduce_snail_num(snailSum)
	end

	-- Debugging
	--[[
	for _,snailNum in ipairs(snailNums) do
		explode_num(snailNum)
		table_deepLinearPrint(snailNum)
	end
	--]]

	print("FILE:",file)

	table_deepLinearPrint(snailSum)

	local answer = 0

	--print("For File:",file,"Answer is:",answer)
end
