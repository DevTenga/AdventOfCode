-- Advent of Code: Day 6,Part 2
-- DevTenga
-- 06/12/2021

-- https://adventofcode.com/2021/day/6

-- ========================== Table Utilities ========================== --

function table_join( parent, ... )
	parent = parent or {}
	for _,t in pairs {...} do
		for k,v in next, t do
			parent[k] = parent[k] and parent[k] + 1 or 1
		end
	end
	return parent
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

	local answer = 0
	local currentGroup = {}
	local currentPerson = {}

	for char,space in string.gmatch(contents,"(%w)(%s*)") do
		currentPerson[char] = true
		
		if string.match(space,"\n\n") then
			currentGroup[#currentGroup + 1] = currentPerson
			local count = #currentGroup
			local countTable = table_join(nil,table.unpack(currentGroup))
			
			-- Debugging
			-- table_deepPrint(countTable)

			for _,v in pairs(countTable) do
				if v == count then answer = answer + 1 end
			end

			-- Debugging
			-- print("SUM:",answer)

			currentGroup = {}
			currentPerson = {}
		elseif string.match(space,"\n") then
			currentGroup[#currentGroup + 1] = currentPerson
			currentPerson = {}
		end

	end

	currentGroup[#currentGroup + 1] = currentPerson
	local count = #currentGroup
	local countTable = table_join(nil,table.unpack(currentGroup))

	-- Debugging
	-- table_deepPrint(countTable)

	for _,v in pairs(countTable) do
		if v == count then answer = answer + 1 end
	end


	print("For File:",file,"Answer is:",answer)
end
