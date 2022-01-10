-- Advent of Code: Day 22,Part 1
-- DevTenga
-- 22/12/2021

-- https://adventofcode.com/2021/day/22

for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	for _ in string.gmatch(contents,"regex") do
		
	end

	local answer = 0

	print("For File:",file,"Answer is:",answer)
end
