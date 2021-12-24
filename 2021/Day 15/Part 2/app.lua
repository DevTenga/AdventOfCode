-- Advent of Code: Day 15,Part 2
-- DevTenga
-- 15/12/2021

-- https://adventofcode.com/2021/day/15

for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	for _ in string.gmatch(contents,"regex") do
		
	end

	local answer = 0

	print("For File:",file,"Answer is:",answer)
end
