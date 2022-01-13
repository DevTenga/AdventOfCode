-- Advent of Code: Day 10,Part 1
-- DevTenga
-- 13/01/2022

-- https://adventofcode.com/2020/day/10

for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	local jolts = {0}

	local jolts_3, jolts_1 = 0,0
	local idx = 2

	for jolt in string.gmatch(contents,"(%d+)\n") do
		jolts[idx] = tonumber(jolt)
		idx = idx + 1
	end

	jolts[idx] = tonumber(string.match(contents,"(%d+)$"))

	table.sort(jolts)
	jolts[idx + 1] = jolts[idx] + 3

	for idx, jolt in ipairs(jolts) do
		print(jolt)
		local _,nextJolt = next(jolts, idx)

		if nextJolt and jolt + 3 == nextJolt then  
			jolts_3 = jolts_3 + 1
		elseif nextJolt and jolt + 1 == nextJolt then
			jolts_1 = jolts_1 + 1
		end
	end

	local answer = jolts_1 * jolts_3

	print("For File:",file,"Answer is:",answer, jolts_1, jolts_3)
end
