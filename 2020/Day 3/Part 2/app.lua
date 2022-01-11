-- Advent of Code: Day 3,Part 2
-- DevTenga
-- 11/01/2021

-- https://adventofcode.com/2020/day/3

-- ========================== Table Utilities ========================== --

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

	local map = {{}}
	local idx,innerIdx,base,hasBase = 0,0,1,false

	for char,space in string.gmatch(contents,"(.)(%s*)") do
		if not map[idx] then map[idx] = {} end
		map[idx][innerIdx] = char

		if string.match(space,"\n") then
			hasBase = true
			idx = idx + 1
			innerIdx = 0
		else
			innerIdx = innerIdx + 1
			if not hasBase then base = base + 1 end
		end
	end

	local function count_trees(rightSlope,downSlope)
		idx,innerIdx = 0,0
		local trees = 0

		local element = map[idx][innerIdx]
		repeat
			if element == "#" then 
				trees = trees + 1
			end
			idx = idx + downSlope
			innerIdx = (innerIdx + rightSlope) % base
			element = map[idx] and map[idx][innerIdx]
		until not element

		return trees
	end
	
	local answer = count_trees(1,1)
	* count_trees(3,1)
	* count_trees(5,1)
	* count_trees(7,1)
	* count_trees(1,2)


	print("For File:",file,"Answer is:",answer)
end
