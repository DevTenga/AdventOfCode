-- Advent of Code: Day 5,Part 2
-- DevTenga
-- 11/01/2021

-- https://adventofcode.com/2020/day/5

-- Sample DOES NOT WORK.

-- ========================== Table Utilities ========================== --
function table_find(t,v)
	for idx = 0, #t do
		val = t[idx]
		if v == val then return idx end
	end
end

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

	local max = math.max(table.unpack(passes))
	local answer = 0

	for i = 0, max do
		print(i)
		if 
			table_find(passes, i + 1) 
			and table_find(passes, i - 1) 
			and not table_find(passes, i) 
		then
			answer = i
			break
		end
	end

	print("For File:",file,"Answer is:",answer)
end
