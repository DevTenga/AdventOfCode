-- Advent of Code: Day 24,Part 2
-- DevTenga
-- 12/01/2022

-- https://adventofcode.com/2021/day/24

for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	for _ in string.gmatch(contents,"regex") do
		
	end

	local answer = 0

	print("For File:",file,"Answer is:",answer)
end
