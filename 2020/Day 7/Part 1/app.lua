-- Advent of Code: Day 7,Part 1
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

	local function check_bag(bag, bagContents)
		if bagsMem[bag] ~= nil then return bagsMem[bag] end
		
		if table_find(bagContents._bags,"shiny gold") then
			bagsMem[bag] = true
			return true
		else
			bagsMem[bag] = false
			for _,innerBag in ipairs(bagContents._bags) do
				
				local innerBagContents = bagRules[innerBag]
				if not innerBagContents then
					bagsMem[innerBag] = false
				else
					local res = check_bag(innerBag, innerBagContents)
					if res then 
						bagsMem[bag] = true
						return res 
					end
				end

			end
			return false
		end
	end

	local answer = 0

	for bag, bagContents in pairs(bagRules) do
		if check_bag(bag, bagContents) then
			answer = answer + 1
		end
	end

	print("For File:",file,"Answer is:",answer)
end
