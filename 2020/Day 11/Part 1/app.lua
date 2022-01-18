-- Advent of Code: Day 11,Part 1
-- DevTenga
-- 14/01/2022

-- https://adventofcode.com/2020/day/11

for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	for _ in string.gmatch(contents,"regex") do
		
	end

	local answer = 0

	print("For File:",file,"Answer is:",answer)
end
