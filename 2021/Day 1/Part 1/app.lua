-- Advent of Code: Day 1, Part 1
-- DevTenga
-- 01/12/2021

-- https://adventofcode.com/2021/day/1

for _,file in ipairs(arg) do
	local lastNum = nil
	local counter = 0
	local contents = io.open(file):read("*all")

	for num in string.gmatch(contents,"(%d+)%s-") do
		num = tonumber(num)
		
		if lastNum and num > lastNum then
			counter = counter + 1
		end

		lastNum = num
	end

	print("For File:",file,"Answer is:",counter)
end


