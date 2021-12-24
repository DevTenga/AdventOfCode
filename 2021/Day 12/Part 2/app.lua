-- Advent of Code: Day 12,Part 2
-- DevTenga
-- 12/12/2021

-- https://adventofcode.com/2021/day/12

local function table_find(t,v)
	for idx = 0, #t do
		val = t[idx]
		if v == val then return idx end
	end
end

for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	local pointerTree = {}
	local visited = {}

	local currentPointer = "start"

	local paths = 0

	local function step_through_tree(at)
		local currentNode = pointerTree[currentPointer]

		if #currentNode == 0 then return end

		local levelPointer = currentPointer
		local levelAt = at

		for idx,node in ipairs(currentNode) do
			currentPointer = levelPointer
			at = levelAt
			if node == "end" then
				paths = paths + 1
				visited = {}
				print("PATH TRAVERSED WAS:",at .. ",end")
			elseif string.lower(node) == node and node ~= "start" and node ~= "end" then
				local visitChecker = {}
				local foundTwice = false

				for lower in string.gmatch(at,"(%l+)") do
					local count = visitChecker[lower]
					if count then
						visitChecker[lower] = count + 1
						foundTwice = true
					else
						visitChecker[lower] = 1
					end 
				end

				if not visitChecker[node] or not foundTwice then
					currentPointer = node
					at = step_through_tree(at .. "," .. node)
				end
			elseif string.upper(node) == node then
				currentPointer = node
				at = step_through_tree(at .. "," .. node)
			end
		end

	end

	for startNode,finishNode in string.gmatch(contents,"(%w+)%-(%w+)") do
		if not pointerTree[startNode] then
			pointerTree[startNode] = {}
		end

		if not pointerTree[finishNode] then
			pointerTree[finishNode] = {}
		end

		pointerTree[finishNode][#pointerTree[finishNode] + 1] = startNode
		pointerTree[startNode][#pointerTree[startNode] + 1] = finishNode
	end

	-- Debugging
	io.stdout:write("{{\n")
	for key,list in pairs(pointerTree) do 

		io.stdout:write("\t[\""..key.."\"] = {")
		for _,node in ipairs(list) do
			io.stdout:write("*"..node..",")
		end
		io.stdout:write("}\n")
	end
	io.stdout:write("\n}}\n")

	step_through_tree("start")

	local answer = paths

	print("For File:",file,"Answer is:",answer)
end
