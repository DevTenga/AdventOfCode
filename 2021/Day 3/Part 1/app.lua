-- Advent of Code: Day 3,2
-- DevTenga
-- 03/12/2021

-- https://adventofcode.com/2021/day/3

for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	local currentIdx = 0
	local bits = {}
	local final = {
		gamma = {},
		epsilon = {}
	}

	local function put_bit(char, idx)
		
		if not bits[idx] then
			bits[idx] = {}
		end

		local arr = bits[idx]		

		arr[#arr + 1] = char
	end

	local function get_final(idx)
		local counter = {
			[0] = 0,
			[1] = 0
		}
		
		for _,bit in ipairs(bits[idx]) do
			bit = tonumber(bit)
			counter[bit] = counter[bit] + 1
		end

		if counter[1] > counter[0] then
			final.gamma[idx] = 1
			final.epsilon[idx] = 0
		else
			final.gamma[idx] = 0
			final.epsilon[idx] = 1
		end
	end

	local function get_decimal_from_bin(bin_table)
		local maxPower = #bin_table
		local decimal = 0

		for i = 1,maxPower do
			decimal = decimal + 2 ^ (maxPower - i) * bin_table[i]
		end

		return decimal
	end

	for char in string.gmatch(contents,"(.)") do
		if char == "\n" then
			currentIdx = 0
		else
			currentIdx = currentIdx + 1
			put_bit(char,currentIdx)
		end
	end

	for i = 1,#bits do
		get_final(i)
	end

	local gamma = get_decimal_from_bin(final.gamma)
	local epsilon = get_decimal_from_bin(final.epsilon)

	local answer = gamma * epsilon
	
	print("For File:",file,"Answer is:",answer)
end
