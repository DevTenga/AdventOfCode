-- Advent of Code: Day 6,Part 1
-- DevTenga
-- 06/12/2021

-- https://adventofcode.com/2021/day/6

for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	local answer = 0
	local currentGroup = {}

	for char,space in string.gmatch(contents,"(%w)(%s*)") do
		currentGroup[char] = true
		if string.match(space,"\n\n") then
			for _ in pairs(currentGroup) do
				answer = answer + 1
			end
			currentGroup = {}
		end
	end

	for _ in pairs(currentGroup) do
		answer = answer + 1
	end


	print("For File:",file,"Answer is:",answer)
end
