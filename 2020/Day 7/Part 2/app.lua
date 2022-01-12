-- Advent of Code: Day 7,Part 2
-- DevTenga
-- 11/01/2022

-- https://adventofcode.com/2020/day/7

-- ========================== Table Utilities ========================== --
function table_find(t,v)
	for idx = 0, #t do
		val = t[idx]
		if v == val then return idx end
	end
end

function table_deepPrint(t,tabCount,_isRecursive)
	tabCount = tabCount or 0
	if not _isRecursive then print(string.rep("\t",tabCount).."{") end
	for k,v in next,t do
		if type(v) ~= "table" then
			print(string.rep("\t",tabCount + 1)..'['..k..'] = '..v..",")
		else
			print(string.rep("\t",tabCount + 1)..'['..k..'] = {')
			table_deepPrint(v,tabCount + 1,true)
		end
	end
	print(string.rep("\t",tabCount).."}")
	if not _isRecursive then print("\n\n======================\n\n") end
end

-- ============================ Code Flow ============================== --
for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	local bagRules = {}
	local bagsMem = {} -- For memoization logic.

	for bagType, bagContents in string.gmatch(contents,"(%w[%w%s]+) bags contain (%d[%d%w%s%,]+)%.") do
		local currentBag = {}
		local _bags = {}
		for count, bag in string.gmatch(bagContents, "(%d+)%s*([%w%s]-) bags*%s*[%,%.]*") do
			currentBag[bag] = count
			_bags[#_bags + 1] = bag
		end
		currentBag._bags = _bags
		bagRules[bagType] = currentBag
	end

	local function tally_bags(bag, bagContents)
		if not bagContents then return 0 end
		if bagsMem[bag] then return bagsMem[bag] end

		local sum = 0
		for _,innerBag in ipairs(bagContents._bags) do
			local innerBagContents = bagRules[innerBag]
			local count = bagContents[innerBag]

			sum = sum + count + count * tally_bags(innerBag, innerBagContents)
		end
		bagsMem[bag] = sum
		return sum
	end

	local answer = tally_bags("shiny gold",bagRules["shiny gold"])

	print("For File:",file,"Answer is:",answer)
end
