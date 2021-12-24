-- Advent of Code: Day 9,Part 2
-- DevTenga
-- 11/12/2021

-- https://adventofcode.com/2021/day/9

local function table_find(t,v)
	for i,n in ipairs(t) do
		if n == v then return i end
	end 
end

local function math_max3(t)
	local max0, max1, max2 = 0,0,0

	for _,v in ipairs(t) do 
		if v >= max0 then
			max2 = max1
			max1 = max0
			max0 = v
		elseif v >= max1 then
			max2 = max1
			max1 = v
		elseif v > max2 then
			max2 = v
		end
	end

	return max0, max1, max2
end

local function math_productOf(...)
	local prod = 1
	for _,val in ipairs({...}) do
		prod = prod * val
	end
	return prod
end

for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	local base,baseSet = 0,false

	local smoke = {}
	local basins = {}
	local low_idx = {}
	local basin_idx = {}

	for height,space in string.gmatch(contents,"(%d)(%s*)") do
		height = tonumber(height)
		
		if not baseSet and string.match(space,"\n") then
			base = base + 1
			baseSet = true
		elseif not baseSet then
			base = base + 1
		end

		smoke[#smoke + 1] = height
	end


	local function get_hIdx_table(idx)
		local elTable

		if (idx - 1) % base == 0 then
			elTable = {
				idx - base,
				idx + 1,
				idx + base
			} 
		elseif idx % base == 0 then
			elTable = {
				idx - base,
				idx - 1,
				idx + base
			}
		else
			elTable = {
				idx - base,
				idx - 1,
				idx + 1, 
				idx + base
			}
		end
		return elTable
	end

	local function test_heights(val,elTable)
		for _,hIdx in ipairs(elTable) do
			if smoke[hIdx] and smoke[hIdx] <= val then return false end
		end
		return true 
	end

	local function view_low_points()
		local nlCounter = 1
		for i = 1,#smoke do
			
			if table_find(low_idx,i) then
				io.stdout:write("\027[32m",smoke[i],"\027[0m")
			elseif table_find(basin_idx,i) then
				io.stdout:write("\027[35m",smoke[i],"\027[0m")
			else
				io.stdout:write(smoke[i])
			end

			if nlCounter == base then
				io.stdout:write("\n")
				nlCounter = 1 
			else
				nlCounter = nlCounter + 1
			end

		end

		io.stdout:write("\n\n")
	end


	local Checker = {add = 1}
	

	function Checker:right(idx,source)
		--print("RIGHT CHECK OF",idx)
		local size = 0

		local i = idx + 1

		while smoke[i] and not table_find(basin_idx,i) and smoke[i] < 9 and (i - 1) % base ~= 0 do
			basin_idx[#basin_idx + 1] = i
			size = size + 1
			if source == "top" or source == "all" or not smoke[i + base] then size = size + self:top(i,"all") end
			if source == "bottom" or source == "all" or not smoke[i - base] then size = size + self:bottom(i,"all") end
			i = i + 1
		end

		return size
	end

	function Checker:left(idx,source)
		--print("LEFT CHECK OF",idx)
		local size = 0

		local i = idx - 1

		while smoke[i] and not table_find(basin_idx,i) and smoke[i] < 9 and i % base ~= 0 do
			basin_idx[#basin_idx + 1] = i
			size = size + 1
			if source == "top" or source == "all" or not smoke[i + base] then size = size + self:top(i,"all") end
			if source == "bottom" or source == "all" or not smoke[i - base] then size = size + self:bottom(i,"all") end
			i = i - 1
		end

		return size
	end

	function Checker:top(idx,source)
		--print("TOP CHECK OF",idx)
		local size = 0

		local i = idx - base

		while smoke[i] and not table_find(basin_idx,i) and smoke[i] < 9 do
			basin_idx[#basin_idx + 1] = i
			size = size + 1
			if source == "right" or source == "all" or not smoke[i - 1] then size = size + self:right(i,"all") end
			if source == "left" or source == "all" or not smoke[i + 1] then size = size + self:left(i,"all") end
			i = i - base
		end

		return size
	end

	function Checker:bottom(idx,source)
		--print("BOTTOM CHECK OF",idx)
		local size = 0

		local i = idx + base

		while smoke[i] and not table_find(basin_idx,i) and smoke[i] < 9 do
			basin_idx[#basin_idx + 1] = i
			size = size + 1
			if source == "right" or source == "all" or not smoke[i - 1] then size = size + self:right(i,"all") end
			if source == "left" or source == "all" or not smoke[i + 1] then size = size + self:left(i,"all") end
			i = i + base
		end

		return size
	end

	function Checker:check(idx)
		self.add = 0
		return self.add + Checker:right(idx,"all") 
		+ Checker:left(idx,"all")
		+ Checker:top(idx,"all")
		+ Checker:bottom(idx,"all")
	end

	for idx,val in ipairs(smoke) do
		if test_heights(val,get_hIdx_table(idx)) then
			low_idx[#low_idx + 1] = idx
		end
	end

	view_low_points()

	for _,idx in ipairs(low_idx) do
		local size = Checker:check(idx)
		basins[#basins + 1] = size 
	end  

	view_low_points()

	for _,size in ipairs(basins) do
		print("BASIN.SIZE = ",size)
	end

	local largest, larger, large = math_max3(basins)
	print("MAX3:", largest, larger, large) 

	local answer = math_productOf(largest, larger, large)

	print("For File:",file,"Answer is:",answer)
end
