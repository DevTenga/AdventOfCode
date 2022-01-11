-- Advent of Code: Day 1,Part 1
-- DevTenga
-- 11/01/2021

-- https://adventofcode.com/2020/day/1

for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	local nums = {}
	local idx = 1
	local answer = nil

	for num in string.gmatch(contents,"(%d+)") do
		num = tonumber(num)

		for _, otherNum in next, nums do
			if num + otherNum == 2020 then
				answer = num * otherNum
				break
			end
		end

		if answer then break end

		nums[idx] = num
		idx = idx + 1
	end
	print("For File:",file,"Answer is:",answer)
end
