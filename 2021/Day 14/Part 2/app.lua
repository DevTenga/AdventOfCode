-- Advent of Code: Day 14,Part 2
-- DevTenga
-- 14/12/2021

-- https://adventofcode.com/2021/day/14

-- As a table is referenced by value, we copy it, otherwise the 
-- memoized value would change.
function table_copy(t)
	local _t = {}
	for k,v in next,t do _t[k] = v end 
	return _t
end

for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	-- For this puzzle, following the direction by brute force 
	-- would yield the program for very long. A better solution 
	-- would be memoization. We can store the expected value in
	-- a memory (cache) table and if we encounter a key at a 
	-- certain depth which is in the memoized table, we do not
	-- recalculate the value, rather just copy them.

	-- I got the idea of implementing memoization from the post of:
	-- u/zia_sun
	-- in the solution megathread of the subreddit. Though I didn't 
	-- take a look at their code (I swear), they mentioned that they 
	-- used memoization in the title.

	local insertions = {}
	local memTable = {}

	local Combiner = {}
	Combiner.__index = Combiner
	Combiner.__tostring = function() return "Combiner Object" end

	function Combiner.new()
		return setmetatable({tables = {}},Combiner)
	end

	function Combiner:collect(t)
		self.tables[#self.tables + 1] = t
		return self
	end

	-- Debugging
	function Combiner:show(msg)
		for i = 1, #self.tables do
			for k,v in pairs(self.tables[i]) do
				print("SHOW:",k,v)
			end
			print("---")
		end
		print("===")

		return self
	end

	function Combiner:join()
		local main = self.tables[1]
		local len = #self.tables

		if len >= 2 then
			for i = 2, len do
				for k,v in pairs(self.tables[i]) do
					if not main[k] then 
						main[k] = v
					else
						main[k] = main[k] + v 
					end
				end
			end
		end

		return main
	end

	local didCount = false

	local function count_str(str,d)
		local charMap = {}

		for i = 1, #str do
			local char = string.sub(str, i, i)
			if charMap[char] then 
				charMap[char] = charMap[char] + 1
			else
				charMap[char] = 1
			end
		end

		return charMap
	end


	local function subdivide_str(str, currentDepth, maxDepth, indexAt)
		if not memTable[currentDepth] then memTable[currentDepth] = {} end
		
		local firstChar = string.sub(str, 1, 1)
		local secondChar = string.sub(str, 2, 2)
		local insertion = insertions[firstChar .. secondChar]
		local memVal = memTable[currentDepth][str]

		if currentDepth < maxDepth and memVal then
			-- Debugging
			print("MEM VAL:", str.." (".. currentDepth .."): {")
			for k,v in pairs(memVal) do
				print("\t"..'"'..k..'" = '..v)
			end
			print "}\n"

			return table_copy(memVal)

		elseif currentDepth == maxDepth - 1 and insertion then
			local collection
			
			collection = subdivide_str(firstChar .. insertion, currentDepth + 1, maxDepth, indexAt)

			local charMap = Combiner.new():collect(collection):join()

			-- Debugging
			print("UPPER EQUAL:", str.." (".. currentDepth .."): {")
			for k,v in pairs(charMap) do
				print("\t"..'"'..k..'" = '..v)
			end
			print "}\n"

			memTable[currentDepth][str] = memTable[currentDepth][str] or table_copy(charMap)
			return charMap 

		elseif currentDepth < maxDepth and insertion then

			local charMap = Combiner.new()
			:collect(subdivide_str(firstChar .. insertion, currentDepth + 1, maxDepth, indexAt) )
			:collect(subdivide_str(insertion .. secondChar, currentDepth + 1, maxDepth, indexAt) )
			:join()

			-- Debugging
			print("UPPER:", str.." ("..currentDepth.."): {")
			for k,v in pairs(charMap) do
				print("\t"..'"'..k..'" = '..v)
			end
			print "}\n"

			memTable[currentDepth][str] = memTable[currentDepth][str] or table_copy(charMap)
			return charMap

		elseif currentDepth == maxDepth then
			local charMap, firstChar = count_str(str, currentDepth)
			
			-- Debugging
			print("LOWER:", str.." (".. currentDepth .."): {")
			for k,v in pairs(charMap) do
				print("\t"..'"'..k..'" = '..v)
			end
			print "}\n"

			return charMap
		end
	end

	local mainStr = string.match(contents,"(%w+)\n\n")
	for letters,insertion in string.gmatch(contents,"(%w+)%s*->%s*(%w+)") do
		insertions[letters] = insertion
	end

	local min, max = math.huge,0

	local combiner = Combiner.new()

	for i = 1, #mainStr - 1 do
		combiner:collect(subdivide_str(string.sub(mainStr, i, i+1), 0, 40))
	end

	local len = #mainStr
	local lastChar = string.sub(mainStr,len,len)

	local charMap = combiner:join()
	charMap[lastChar] = (charMap[lastChar] or 0) + 1

	-- Debugging
	print("FINAL: {")
	for k,v in pairs(charMap) do
		print("\t"..'"'..k..'" = '..v)
	end
	print "}\n"

	local charArr = {}

	for _,val in pairs(charMap) do
		charArr[#charArr + 1] = val 
	end

	local answer = math.max(table.unpack(charArr)) - math.min(table.unpack(charArr))--]]

	print("For File:",file,"Answer is:",answer)
end
