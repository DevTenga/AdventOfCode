-- Advent of Code: Day 20,Part 2
-- DevTenga
-- 20/12/2021

-- https://adventofcode.com/2021/day/20

-- ========================== Table Utilities ========================== --

function table_deepPrint(t,tabCount,_isRecursive)
	tabCount = tabCount or 0
	if not _isRecursive then print(string.rep("\t",tabCount)..'{') end
	for k,v in next,t do
		if type(v) ~= "table" then
			print(string.rep("\t",tabCount + 1)..'['..k..'] = '..v..',')
		else
			print(string.rep("\t",tabCount + 1)..'['..k..'] = {')
			table_deepPrint(v,tabCount + 1,true)
		end
	end
	print(string.rep("\t",tabCount)..'}')
	if not _isRecursive then print("\n\n======================\n\n") end
end

function table_deepCopy(t)
	local _t = {}

	for k,v in next,t do
		if type(v) ~= "table" then
			_t[k] = v
		else
			_t[k] = table_deepCopy(v)
		end
	end
	return _t
end

function table_deepLinearPrint(t, _isRecursive)
	if not t then return end
	local _str = '['
	
	for _,v in next,t do
		_str = _str .. (type(v) ~= "table" and v or table_deepLinearPrint(v, true))
	end

	_str = _str..']'
	if not _isRecursive then print(_str) else return _str end
end

-- =========================== Core Program ============================ --

for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	local pickingAlgo = true
	local algo = {}
	local input = {{}}
	local output = {{}}
	local filler = '.' -- This is the value that will remain in the outer cells.

	local inputIdx,inputInnerIdx,algoIdx = 0,0,0

	local function get_decimal_from_bin(bin_table)
		local maxPower = #bin_table
		local decimal = 0

		for i = 1,maxPower do
			decimal = decimal + (2 ^ (maxPower - i)) * (bin_table[i] == '#' and 1 or 0)
		end
		return decimal
	end


	for char,space in string.gmatch(contents,"(.)(%s*)") do
		if pickingAlgo then
			algo[algoIdx] = char
			algoIdx = algoIdx + 1
		else
			if not input[inputIdx] then
				input[inputIdx] = {}
			end

			input[inputIdx][inputInnerIdx] = char
			inputInnerIdx = inputInnerIdx + 1
		end

		if string.match(space,"\n\n") then
			pickingAlgo = false
			inputIdx = 0
			inputInnerIdx = 0
		elseif string.match(space,"\n") then
			inputIdx = inputIdx + 1
			inputInnerIdx = 0
		end
	end

	local function get_idx(pixelX,pixelY)
		local pixel = {}
		for i = -1,1,1 do
			for j = -1,1,1 do
				pixel[#pixel + 1] = input[pixelY + i] and input[pixelY + i][pixelX + j] or filler
			end
		end
		return pixel
	end

	local function enhance()
		local _output = {{}}

		for i = -1, #input+1 do
			for j = -1, #input+1 do
				
				if not _output[i + 1] then
					_output[i + 1] = {}
				end

				local idx = get_decimal_from_bin(get_idx(j,i))
				local pixel = algo[idx]
				
				-- Degubbing
				--[[
				print(i,j,table_deepLinearPrint(get_idx(j,i),true), idx, pixel)
				for _,v in ipairs(get_idx(j,i)) do io.stdout:write(v or "") end
				print()
				]]
				_output[i + 1][j + 1] = pixel
			end 
		end

		local bin_table = {}
		for i = 1, 9 do bin_table[i] = filler end

		filler = algo[get_decimal_from_bin(bin_table)]
		output = _output
	end

	-- Debugging
	--[[
	print "Input:"
	for i = 0,#input do 
		for j = 0,#input[i] do 
			io.stdout:write(input[i][j]) 
		end 
		io.stdout:write("\n") 
	end
	io.stdout:write("\n\n\n")
	]]
	for _ = 1,50 do
		enhance()
		-- Debugging
		--[[
		for i = 0,#output do 
			for j = 0, #output[i] do 
				io.stdout:write(output[i][j]) 
			end 
			io.stdout:write("\n") 
		end
		io.stdout:write("\n\n\n")
		]]

		input = output
	end

	local answer = 0

	for i = 0,#output do 
		for j = 0, #output[i] do 
			io.stdout:write(output[i][j])
			if output[i][j] == '#' then answer = answer + 1 end 
		end 
		io.stdout:write("\n") 
	end
	io.stdout:write("\n\n\n")

	print("For File:",file,"Answer is:",answer)
end
