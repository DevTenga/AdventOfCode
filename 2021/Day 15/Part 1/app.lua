-- Advent of Code: Day 15,Part 1
-- DevTenga
-- 15/12/2021

-- https://adventofcode.com/2021/day/15

local function table_find(t,v)
	for idx,val in ipairs(t) do if v == val then return idx end end
end

local function table_copy(t)
	local _t = {}
	for k,v in next,t do _t[k] = v end
	return _t
end


for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	-- If the path has a number greater than 6,assume there's 
	-- a better path. (This is not fail-proof, but why not?)
	-- One more shortcut that is taken is, do not go back or 
	-- up.

	local risks = {}
	local correctPaths = {}

	local base
	local baseCounter = 0
	local len = 0

	local function index_sum(t)
		local sum = 0
		for _,idx in next,t do sum = sum + risks[idx] end
		return sum
	end

	for char in string.gmatch(contents,"(.)") do
		
		if char and string.match(char,"\n") then
			if not base then base = baseCounter end
		else
			len = len + 1
			risks[len] = tonumber(char)
			if not base then baseCounter = baseCounter + 1 end
		end
	end


	local function next_thread(idx, visitedPaths, nextPath)
		--print("start",idx,risks[idx],len)
		if idx == len then
			--print("found a path")
			correctPaths[#correctPaths + 1] = table_copy(visitedPaths)
		end

		local rIdx = idx + 1
		local dIdx = idx + base 
		
		if idx % base ~= 0 
			and risks[rIdx]
			--and (not nextPath or nextPath == "right") 
			--and risks[rIdx] < 9 
			--and not table_find(visitedPaths,rIdx) 
		then
			visitedPaths[#visitedPaths + 1] = rIdx
			next_thread(rIdx, table_copy(visitedPaths),"down")
		end

		if  risks[dIdx]
			--and (not nextPath or nextPath == "down") 
			--and risks[dIdx] < 9 
			--and not table_find(visitedPaths,dIdx) 
		then
			print('MOVING DOWN TO:', dIdx)
			visitedPaths[#visitedPaths + 1] = dIdx
			next_thread(dIdx, table_copy(visitedPaths),"right")
		end

	end

	next_thread(1, {})
	local valArr = {}

	print()
	local baseChecker = 1

	for _, val in ipairs(risks) do
		io.stdout:write(val)

		if base == baseChecker then
			io.stdout:write "\n"
			baseChecker = 1 
		else
			baseChecker = baseChecker + 1
		end
	end
	io.stdout:write "\n\n"

	for i,t in ipairs(correctPaths) do
		valArr[i] = index_sum(t)
		--print("PATH:",valArr[i],t)
	end

	local answer = math.min(table.unpack(valArr))

	print("For File:",file,"Answer is:",answer)
end
