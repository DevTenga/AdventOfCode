-- Advent of Code: Day 7,Part 1
-- DevTenga
-- 07/12/2021

-- https://adventofcode.com/2021/day/7

for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	-- The minimum fuel usage can be in either the most
	-- common element (mode) of the data, or the median
	-- of the data.   If it has multiple modes, we will 
	-- check for each of them.   We will also check for 
	-- one or two medians that we find. We will put all
	-- results in a table and find the math.min.

	local positions = {}
	local pAnswers = {}

	local function calculate_cost(pointer)
		local res = 0

		for _,pos in ipairs(positions) do
			res = res + math.abs(pos - pointer)
		end

		return res
	end

	for pos in string.gmatch(contents,"(%d+)") do
		positions[#positions + 1] = tonumber(pos)
	end


	-- The median part
	table.sort(positions)
	local posLen = #positions

	if posLen % 2 == 1 then
		pAnswers[#pAnswers + 1] = positions[(posLen + 1) / 2]
	else
		local median = (positions[posLen / 2] + positions[posLen / 2 + 1]) / 2
		if median % 1 == 0 then
			pAnswers[#pAnswers + 1] = median
		else
			median = median - median % 1
			pAnswers[#pAnswers + 1] = median
			pAnswers[#pAnswers + 1] = median + 1
		end
	end

	-- The mode calculation
	local modeMap = {}
	local max = 0

	for _,val in ipairs(positions) do
		if modeMap[val] then
			modeMap[val] = modeMap[val] + 1
		else
			modeMap[val] = 1
		end

		if modeMap[val] > max then
			max = modeMap[val]
		end
	end

	for val,count in ipairs(modeMap) do
		if count == max then
			pAnswers[#pAnswers + 1] = val 
		end
	end

	-- Plotting the fuel costs in a table
	local costs = {}
	for _,pAnswer in ipairs(pAnswers) do
		costs[#costs + 1] = calculate_cost(pAnswer)
	end	

	-- Answer would be the minimum cost among the selected.
	local answer = math.min(table.unpack(costs))

	print("For File:",file,"Answer is:",answer)
end
