-- Advent of Code: Day 7, Part 2
-- DevTenga
-- 07/12/2021

-- https://adventofcode.com/2021/day/7

for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	-- Ok, I give up. Gonna loop through all
	-- the elements and get the minimum value
	-- by hardcoding. Will reflect on this
	-- once I learn the math.

	local positions = {}
	local pAnswers = {}

	local function calculate_cost(pointer)
		local res = 0

		for _,pos in ipairs(positions) do
			local n = math.abs(pos - pointer)
			res = res + n * (n + 1) / 2
		end

		return res
	end

	for pos in string.gmatch(contents,"(%d+)") do
		positions[#positions + 1] = tonumber(pos)
	end

	for pointer = math.min(table.unpack(positions)), math.max(table.unpack(positions)) do
		costs[#costs + 1] = calculate_cost(pointer)
		print(pointer," = ",calculate_cost(pointer))
	end

	-- Answer would be the minimum cost among the selected.
	local answer = math.min(table.unpack(costs))

	print("For File:",file,"Answer is:",answer)
end
