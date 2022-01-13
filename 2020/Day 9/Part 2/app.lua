-- Advent of Code: Day 9,Part 2
-- DevTenga
-- 13/01/2022

-- https://adventofcode.com/2020/day/9

for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	local startIdx = 1
	local preamble = 25 -- 5 for sample.txt

	local nums = {}

	local res = nil

	for num in string.gmatch(contents,"(%d+)\n") do
		num = tonumber(num)
		res = nil
		
		local len = #nums

		if len >= preamble then

			-- Debugging
			--[[
			for i = startIdx, len do
				print(nums[i])
			end
			print("====")
			]]

			for i = startIdx, len do
				for j = startIdx, len do
					if i ~= j and nums[i] + nums[j] == num then
						res = num
						break
					end
					if res then break end
				end
				if res then break end
			end
			startIdx = startIdx + 1

			if not res then 
				res = num
				break 
			end

		end

		nums[len + 1] = num
	end

	for i = 2, #nums do
		for j = 1, i - 1 do
			local sum = 0
			for k = j, i do
				sum = sum + nums[k]
			end

			if sum == res then
				res = {}
				local idx = 1
				for n = j, i do
					print(nums[n])
					res[idx] = nums[n]
					idx = idx + 1
				end
				break
			end
		end
		if type(res) == "table" then break end
	end


	local max = math.max(table.unpack(res))
	local min = math.min(table.unpack(res))

	local answer = max + min

	print("For File:",file,"Answer is:",answer)
end
