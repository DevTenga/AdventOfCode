-- Advent of Code: Day 5,Part 1
-- DevTenga
-- 05/12/2021

-- https://adventofcode.com/2021/day/5

-- ========================== Core Functions =========================== --
local function get_decimal_from_bin(bin_table)
	local maxPower = #bin_table
	local decimal = 0

	for i = 1,maxPower do
		decimal = decimal + (2 ^ (maxPower - i)) * bin_table[i]
	end
	return decimal
end

-- ============================ Code Flow ============================== --
for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	local passes = {}
	-- Note: F = 0, B = 1
	-- Note: L = 0, R = 1
	for pass in string.gmatch(contents,"(%w+)\n*") do
		local rows = {}
		for char in string.gmatch(pass,"%w") do
			--print(char)
			if char == "F" or char == "L" then
				rows[#rows + 1] = 0
			elseif char == "B" or char == "R" then
				rows[#rows + 1] = 1
			end
		end
		passes[#passes + 1] = get_decimal_from_bin(rows)
		print(passes[#passes])
	end

	local answer = math.max(table.unpack(passes))

	print("For File:",file,"Answer is:",answer)
end
