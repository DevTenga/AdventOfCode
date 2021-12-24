-- Advent of Code: Day 20,Part 1
-- DevTenga
-- 20/12/2021

-- https://adventofcode.com/2021/day/20

for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	local pickingAlgo = true
	local algo = {}
	local input = {{}}
	local output = {{}}

	local inputIdx,inputInnerIdx,algoIdx = 0,0,0

	local function get_decimal_from_bin(bin_table)
		local maxPower = #bin_table
		local decimal = 0

		for i = 1,maxPower do
			decimal = decimal + 2 ^ (maxPower - i) * (bin_table[i] == "." and 0 or 1)
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
				pixel[#pixel + 1] = input[pixelY + i] and input[pixelY + i][pixelX + j] or "."
			end
		end
		return pixel
	end

	local function enhance()
		local _output = {{}}

		for i = -1, #input + 1 do
			local pixels = input[i]
			for j = -1, #input + 1 do
				
				if not _output[i + 1] then
					_output[i + 1] = {}
				end

				local idx = get_decimal_from_bin(get_idx(j,i))
				local pixel = algo[idx]
				--[[for _,v in ipairs(get_idx(j,i)) do io.stdout:write(v or "") end
				print()]]
				_output[i + 1][j + 1] = pixel
			end 
		end

		output = _output
	end

	for i = 0,#input do 
		for j = 0,#input[i] do 
			io.stdout:write(input[i][j]) 
		end 
		io.stdout:write("\n") 
	end
	io.stdout:write("\n\n\n")

	enhance()

	for i = 0,#output do 
		for j = 0, #output[i] do 
			io.stdout:write(output[i][j]) 
		end 
		io.stdout:write("\n") 
	end
	io.stdout:write("\n\n\n")

	input = output
	enhance()

	for i = 0,#output do 
		for j = 0, #output[i] do 
			io.stdout:write(output[i][j]) 
		end 
		io.stdout:write("\n") 
	end
	io.stdout:write("\n\n\n")

	input = output
	enhance()

	local answer = 0


	for i = 0,#output do 
		for j = 0, #output[i] do 
			io.stdout:write(output[i][j])
			if output[i][j] == "#" then answer = answer + 1 end 
		end 
		io.stdout:write("\n") 
	end
	io.stdout:write("\n\n\n")
	print("ALGO::::::")
	print(#algo,algo[512],algo[511])
	for _,c in ipairs(algo) do io.stdout:write(c) end
	io.stdout:write("\n\n\n")



	print("For File:",file,"Answer is:",answer)
end
