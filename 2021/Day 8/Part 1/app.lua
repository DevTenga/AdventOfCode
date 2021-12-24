-- Advent of Code: Day 8,Part 1
-- DevTenga
-- 08/12/2021

-- https://adventofcode.com/2021/day/8

local function table_find(t,v)
	for idx,val in ipairs(t) do
		if v == val then return idx end
	end
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
	local counter = 0

	for outputs in string.gmatch(contents,"[%w ]+ *| *\n*([%w ]+)") do
	
		lineCounter = lineCounter + 1

		for output in string.gmatch(outputs,"(%w+)") do

			local find = table_find(signalSize,#output)
			if find and table_find({1,4,7,8},find) then 
				counter = counter + 1
			end

		end
	end

	local answer = counter

	print("For File:",file,"Answer is:",answer)
end
