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
		
		if string.match(char,"\n") then
			if not base then base = baseCounter end
		else
			len = len + 1
			risks[len] = tonumber(char)
			if not base then baseCounter = baseCounter + 1 end
		end
	end

	local function next_thread(idx, visitedPaths)
		if not risks[idx] then return end
		visitedPaths[#visitedPaths + 1] = idx
		if idx == len then
			correctPaths[#correctPaths + 1] = table_copy(visitedPaths)
			--return true
		end

		local rIdx = idx + 1
		local dIdx = idx + base

		local rRisk = risks[rIdx] or 0
		local dRisk = risks[dIdx] or 0
		
		local res

		if idx % base ~= 0 then
			if (rRisk < dRisk or table_find(visitedPaths, dIdx)) and not table_find(visitedPaths, rIdx) then
				res = next_thread(rIdx, table_copy(visitedPaths))
				
				--[[if not res and not table_find(visitedPaths, dIdx) then
					next_thread(dIdx, table_copy(visitedPaths))
				end]]

			elseif (dRisk < rRisk or table_find(visitedPaths, rIdx)) and not table_find(visitedPaths, dIdx) then
				res = next_thread(dIdx, table_copy(visitedPaths))
				
				--[[if not res and not table_find(visitedPaths, rIdx) then
					next_thread(rIdx, table_copy(visitedPaths))
				end]]
			else
				if not table_find(visitedPaths, dIdx) then
					next_thread(dIdx, table_copy(visitedPaths))
				end

				if not table_find(visitedPaths, rIdx) then
					next_thread(rIdx, table_copy(visitedPaths))
				end
			end
		end

	end

	next_thread(1, {})
	local valArr = {}

	print()
	local baseChecker = 1

	for i,t in ipairs(correctPaths) do
		valArr[i] = index_sum(t)

		-- Debugging
		--[[for idx, val in ipairs(risks) do
			val = table_find(t,idx) and '@' or '.'
			io.stdout:write(val)

			if base == baseChecker then
				io.stdout:write "\n"
				baseChecker = 1 
			else
				baseChecker = baseChecker + 1
			end
		end
		io.stdout:write "\n\n"--]]
	end

	local answer = math.min(table.unpack(valArr))
	print "SOLUTION:"
	local ans = correctPaths[table_find(valArr, answer)]
	answer = answer - risks[1] -- For removing the value of the first cell which is never entered.

	for idx, val in ipairs(risks) do
		val = table_find(ans,idx) and "\027[32m"..val.."\027[0m" or val
		io.stdout:write(val)

		if base == baseChecker then
			io.stdout:write "\n"
			baseChecker = 1 
		else
			baseChecker = baseChecker + 1
		end
	end
	io.stdout:write "\n"


	print("For File:",file,"Answer is:",answer)
end
