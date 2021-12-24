-- Advent of Code: Day 1, Part 2
-- DevTenga
-- 01/12/2021

-- https://adventofcode.com/2021/day/1

for _,file in ipairs(arg) do
	local nums = {}
	local contents = io.open(file):read("*all")

	for num in string.gmatch(contents,"(%d+)%s-") do
		num = tonumber(num)
		nums[#nums + 1] = num
	end
	
	local counter = 0

	for idx = 1,#nums do
		if nums[idx + 1] and nums[idx - 2] and nums[idx - 1] then
			if nums[idx - 1] + nums[idx] + nums[idx + 1] > nums[idx - 2] + nums[idx - 1] + nums[idx] then
				counter = counter + 1
			end
		end
	end

	print("For File:",file,"Answer is:",counter)
end


