-- Advent of Code: Day 1,Part 2
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

		for outerIdx, outerNum in next, nums do
			for innerIdx, innerNum in next, nums do
				if outerIdx ~= innerIdx and num + outerNum + innerNum == 2020 then
					answer = num * outerNum * innerNum
					break
				end
			end
			if answer then break end
		end

		if answer then break end

		nums[idx] = num
		idx = idx + 1
	end
	print("For File:",file,"Answer is:",answer)
end
