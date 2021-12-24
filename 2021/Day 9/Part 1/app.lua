-- Advent of Code: Day 9,Part 1
-- DevTenga
-- 11/12/2021

-- https://adventofcode.com/2021/day/9

local function table_find(t,v)
	for i,n in ipairs(t) do
		if n == v then return i end
	end 
end


for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	local base,baseSet = 0,false

	local smoke = {}
	local low_points = {}

	local low_idx = {}

	for height,space in string.gmatch(contents,"(%d)(%s*)") do
		height = tonumber(height)
		
		if not baseSet and string.match(space,"\n") then
			base = base + 1
			baseSet = true
		elseif not baseSet then
			base = base + 1
		end

		smoke[#smoke + 1] = height
	end

	local function get_hIdx_table(idx)
		local elTable

		if (idx - 1) % base == 0 then
			elTable = {
				idx - base,
				idx + 1,
				idx + base
			} 
		elseif idx % base == 0 then
			elTable = {
				idx - base,
				idx - 1,
				idx + base
			}
		else
			elTable = {
				idx - base,
				idx - 1,
				idx + 1, 
				idx + base
			}
		end
		return elTable
	end

	local function test_heights(val,elTable)
		for _,hIdx in ipairs(elTable) do
			if smoke[hIdx] and smoke[hIdx] < val then return false end
		end
		return true 
	end
	
	local function view_low_points()
		local nlCounter = 1
		for i = 1,#smoke do
			
			if table_find(low_idx,i) then
				io.stdout:write("\027[32m",smoke[i],"\027[0m")
			else
				io.stdout:write(smoke[i])
			end

			if nlCounter == base then
				io.stdout:write("\n")
				nlCounter = 1 
			else
				nlCounter = nlCounter + 1
			end

		end

		io.stdout:write("\n\n")
	end


	for idx,val in ipairs(smoke) do
		if test_heights(val,get_hIdx_table(idx)) then
			low_points[#low_points + 1] = val
			low_idx[#low_idx + 1] = idx
		end

	end

	view_low_points()

	local answer = 0

	for _,val in ipairs(low_points) do
		answer = answer + val
	end

	answer = answer + #low_points

	print("For File:",file,"Answer is:",answer)
end
