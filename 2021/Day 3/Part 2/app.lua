-- Advent of Code: Day 3, Part 2
-- DevTenga
-- 03/12/2021

-- https://adventofcode.com/2021/day/3

for _,file in ipairs(arg) do
	-- init
	local contents = io.open(file):read("*all")
	
	local vIdx = 0
	local hIdx = 1
	
	local vBitsO2 = {}
	local hBitsO2 = {}
	local vBitsCO2 = {}
	local hBitsCO2 = {}

	local function put_bit(char, vIdx, hIdx)
		if not vBitsO2[vIdx] then
			vBitsO2[vIdx] = {}
		end

		if not hBitsO2[hIdx] then
			hBitsO2[hIdx] = {}
		end

		if not vBitsCO2[vIdx] then
			vBitsCO2[vIdx] = {}
		end

		if not hBitsCO2[hIdx] then
			hBitsCO2[hIdx] = {}
		end

		local ho = hBitsO2[hIdx]
		local hc = hBitsCO2[hIdx]
		local vo = vBitsO2[vIdx]
		local vc = vBitsCO2[vIdx]

		ho[#ho + 1] = char
		hc[#hc + 1] = char
		vo[#vo + 1] = char
		vc[#vc + 1] = char
	end

	local function get_decimal_from_bin(bin_table)
		local maxPower = #bin_table
		local decimal = 0

		for i = 1,maxPower do
			decimal = decimal + 2 ^ (maxPower - i) * bin_table[i]
		end

		return decimal
	end

	-- O2
	local function reput_bits_O2()
		local _vBitsO2 = {}
		local len = #hBitsO2[1]
		
		for i = 1, len do
			for j = 1, #hBitsO2 do
				if not _vBitsO2[i] then _vBitsO2[i] = {} end
				_vBitsO2[i][j] = hBitsO2[j][i]
			end
		end

		vBitsO2 = _vBitsO2
	end

	local function get_higher_vertical_O2(idx)
		
		local counter = {
			[0] = 0,
			[1] = 0
		}
		
		for _,bit in ipairs(vBitsO2[idx]) do
			bit = tonumber(bit)
			counter[bit] = counter[bit] + 1
		end

		if counter[1] >= counter[0] then
			return 1
		else
			return 0
		end
	end

	local function construct_O2(idx, higher)
		local _O2 = {}

		for i = 1, #hBitsO2 do
			if tonumber(vBitsO2[idx][i]) == higher then
				_O2[#_O2 + 1] = hBitsO2[i]
			end
		end

		hBitsO2 = _O2
		reput_bits_O2()
	end

	-- CO2
	local function reput_bits_CO2()
		local _vBitsCO2 = {}
		local len = #hBitsCO2[1]
		
		for i = 1, len do
			for j = 1, #hBitsCO2 do
				if not _vBitsCO2[i] then _vBitsCO2[i] = {} end
				_vBitsCO2[i][j] = hBitsCO2[j][i]
			end
		end

		vBitsCO2 = _vBitsCO2
	end

	local function get_lower_vertical_CO2(idx)
		
		local counter = {
			[0] = 0,
			[1] = 0
		}
		
		for _,bit in ipairs(vBitsCO2[idx]) do
			bit = tonumber(bit)
			counter[bit] = counter[bit] + 1
		end

		if counter[0] <= counter[1] then
			return 0
		else
			return 1
		end
	end

	local function construct_CO2(idx, lower)
		local _CO2 = {}

		for i = 1, #hBitsCO2 do
			if tonumber(vBitsCO2[idx][i]) == lower then
				_CO2[#_CO2 + 1] = hBitsCO2[i]
			end
		end

		hBitsCO2 = _CO2
		reput_bits_CO2()
	end

	-- Control
	for char in string.gmatch(contents,"(.)") do
		if char == "\n" then
			vIdx = 0
			hIdx = hIdx + 1
		else
			vIdx = vIdx + 1
			put_bit(char, vIdx, hIdx)
		end
	end

	-- O2 Control
	for i = 1, #vBitsO2 do
		if #hBitsO2 == 1 then break end

		local higher = get_higher_vertical_O2(i)
		construct_O2(i, higher)
	end

	-- CO2 Control
	for i = 1, #vBitsCO2 do

		if #hBitsCO2 == 1 then break end

		local lower = get_lower_vertical_CO2(i)
		construct_CO2(i, lower)
	end

	local O2Val = get_decimal_from_bin(hBitsO2[1])
	local CO2Val = get_decimal_from_bin(hBitsCO2[1])

	local answer = O2Val * CO2Val
	print(O2Val, CO2Val)
	

	print("For File:",file,"Answer is:",answer)
end
