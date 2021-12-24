-- Advent of Code: Day 16,Part 1
-- DevTenga
-- 16/12/2021

-- https://adventofcode.com/2021/day/16

local s = string.sub

local function table_copy(t,i,f)
	local _t = {}

	if not i or not f then
		for k,v in next,t do _t[k] = v end 
	else
		i = i or 1
		f = f or #t
		for idx = i, f do
			_t[idx - i + 1] = t[idx]
		end
	end

	return _t
end

local hexChart = {
	["0"] = "0000", 
	["1"] = "0001", 
	["2"] = "0010", 
	["3"] = "0011", 
	["4"] = "0100", 
	["5"] = "0101", 
	["6"] = "0110", 
	["7"] = "0111", 
	["8"] = "1000", 
	["9"] = "1001", 
	["A"] = "1010", 
	["B"] = "1011", 
	["C"] = "1100", 
	["D"] = "1101", 
	["E"] = "1110", 
	["F"] = "1111", 
}

for k,v in pairs(hexChart) do
	hexChart[k] = {s(v,1,1), s(v,2,2), s(v,3,3), s(v,4,4)}
end

local function getBinEquiv(hexStr)
	local binTable = {}

	for i = 1, #hexStr do
		local t = hexChart[string.sub(hexStr,i,i)]
		binTable = table.move(t, 1, #t, #binTable + 1, binTable)
	end

	return binTable
end

local function getDecimalEquiv(binTable)
	local len = #binTable
	local sum = 0

	for i,v in ipairs(binTable) do
		sum = sum + (2 ^ (len - i) * v)
	end

	return sum
end

for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	--[[
		Byte Config:
			1-3: Version Number 
			4-6: Type ID
				Values:
				4 = Literal. Multiple of 4. 1 byte at first denoting boolean.
				Type IDs other than 4 will by followed by a bool bit:
					0 = Next 15 bits would be length in bits of subpackets.
					1 = Next 11 bits would be number of subpackets.

	]]

	--[[
		table.move(
		source: table,
		startIdx: int,
		endIdx: int,
		destStartIdx: int,
		destination: table 
		)

		source = Table from where you want to copy the elements.
		startIdx = Index of the source table from where copying will start.
		endIdx = Index of the source table from where copying will stop.
		destStartIdx = Index of the destination table where copied elements will start pasting from.
		destination = Table where copied elements will be pasted.
	]]

	local binData = getBinEquiv(contents)

	function parse_literal(binTable,nextIdx)
		local literalTable = {}

		local inLoop = true

		while inLoop do
			if binTable[nextIdx] ~= "1" then inLoop = false end
			table.move(binTable, 
				nextIdx + 1, 
				nextIdx + 4, 
				#literalTable + 1, 
				literalTable
			)
			nextIdx = nextIdx + 5
		end

		return getDecimalEquiv(literalTable), nextIdx
	end

	function parse_15_packet(binTable,nextIdx)
		local len = getDecimalEquiv(table_copy(binTable, nextIdx, nextIdx + 14))
		local lenRead = 0
		local value,sum = 0,0

		nextIdx = nextIdx + 15
		local lastIdx = nextIdx

		while lenRead < len do
			value,nextIdx = parse_packet(binTable, nextIdx)
			sum = sum + value
			lenRead = nextIdx - lastIdx
		end

		return sum, nextIdx
	end

	function parse_11_packet(binTable, nextIdx)
		local count = getDecimalEquiv(table_copy(binTable, nextIdx, nextIdx + 10))
		local countRead = 0
		local value,sum = 0,0

		nextIdx = nextIdx + 11

		while countRead < count do
			value,nextIdx = parse_packet(binTable, nextIdx)
			sum = sum + value
			countRead = countRead + 1
		end

		return sum, nextIdx
	end

	local answer = 0

	function parse_packet(binTable,nextIdx)
		nextIdx = nextIdx or 1
		local version = getDecimalEquiv(table_copy(binTable,nextIdx,nextIdx + 2))
		local typeID = getDecimalEquiv(table_copy(binTable,nextIdx + 3, nextIdx + 5))

		answer = answer + version

		if typeID == 4 then 
			return parse_literal(binTable,nextIdx + 6)
		else
			local lenType = binTable[nextIdx + 6]
			
			if lenType == "0" then
				return parse_15_packet(binTable,nextIdx + 7)
			elseif lenType == "1" then
				return parse_11_packet(binTable,nextIdx + 7)
			end

		end
	end

	parse_packet(binData)

	print("For File:",file,"Answer is:",answer)
end
