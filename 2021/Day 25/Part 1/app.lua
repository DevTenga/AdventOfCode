-- Advent of Code: Day 25,Part 1
-- DevTenga
-- 12/01/2022

-- https://adventofcode.com/2021/day/25

-- ========================== Table Utilities ========================== --
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

function table_charPrint(t)
	for _, row in ipairs(t) do
		for _, char in ipairs(row) do
			io.stdout:write(char)
		end
		io.stdout:write('\n')
	end
	io.stdout:write('\n\n')
end

-- ============================ Code Flow ============================== --
for _,file in ipairs(arg) do
	print("Starting File:", file)
	local contents = io.open(file):read("*all")

	local seaFloor = {{}}
	local southHerd = {}
	local eastHerd = {}
	local x,y = 1,1

	for char, space in string.gmatch(contents,"(.)(%s*)") do
		seaFloor[y][x] = char

		if char == 'v' then
			southHerd[#southHerd + 1] = {y,x}
		elseif char == '>' then
			eastHerd[#eastHerd + 1] = {y,x}
		end

		if string.match(space,"\n") then
			y = y + 1
			x = 1
			seaFloor[y] = {}
		else
			x = x + 1
		end
	end

	local function step(stepNo)
		local newFloor = table_deepCopy(seaFloor)

		local didMove = false

		for idx,cucumber in ipairs(eastHerd) do
			local y,x = table.unpack(cucumber)
			local X = seaFloor[y][x + 1] and x + 1 or 1

			local locn = seaFloor[y][X]
			
			if locn == '.' then
				didMove = true
				newFloor[y][x] = '.'
				newFloor[y][X] = '>'
				eastHerd[idx] = {y,X}
			end
		end

		seaFloor = table_deepCopy(newFloor)
		-- Debugging
		--table_charPrint(seaFloor)

		for idx,cucumber in ipairs(southHerd) do
			local y,x = table.unpack(cucumber)
			local Y = seaFloor[y + 1] and y + 1 or 1

			local locn = seaFloor[Y][x]
			
			if locn == '.' then
				-- Debugging
				--print("Moving",y..','..x,"to:",Y..','..x, '('..locn..')')
				didMove = true
				newFloor[y][x] = '.'
				newFloor[Y][x] = 'v'
				southHerd[idx] = {Y,x}
			end
		end

		-- Debugging
		--print("After step:", stepNo)
		--table_charPrint(newFloor)

		seaFloor = newFloor
		return didMove
	end

	local answer = 1

	-- Debugging
	--table_charPrint(seaFloor)

	while step(answer + 1) do
		answer = answer + 1
	end

	print("For File:",file,"Answer is:",answer)
end
