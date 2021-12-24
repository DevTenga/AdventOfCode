-- Advent of Code: Day 20,Part 2
-- DevTenga
-- 20/12/2021

-- https://adventofcode.com/2021/day/20

for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	for _ in string.gmatch(contents,"regex") do
		
	end

	local answer

	print("For File:",file,"Answer is:",answer)
end
