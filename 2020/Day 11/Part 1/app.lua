-- Advent of Code: Day 11,Part 1
-- DevTenga
-- 14/01/2022

-- https://adventofcode.com/2020/day/11

local selector = {
	{-1,-1},
	{-1,0},
	{-1,1},
	{0,-1},
	{0,1},
	{1,-1},
	{1,0},
	{1,1}
}

function show_seating(seating)
	print()
	for _,row in ipairs(seating) do
		for _, char in ipairs(row) do
			io.stdout:write(char)
		end
		print()
	end
	print '\n'
	return seating
end

function count_seats(seating, seat)
	local counter = 0
	
	for _,row in ipairs(seating) do
		for _, char in ipairs(row) do
			counter = char == seat and counter + 1 or counter
		end
	end
	return counter
end

function rotate_seating(seating)
	local newSeating = {}
	
	for idx, row in ipairs(seating) do
		newSeating[idx] = {}
		for innerIdx, seat in ipairs(row) do
			local occCounter = 0
			local empCounter = 0

			for _, pair in ipairs(selector) do
				occCounter = seating[idx + pair[1]] and seating[idx + pair[1]][innerIdx + pair[2]] == "#" and occCounter + 1 or occCounter;
				empCounter = seating[idx + pair[1]] and seating[idx + pair[1]][innerIdx + pair[2]] == "L" and empCounter + 1 or empCounter;
				
				if seat == '#' and occCounter >= 4 then
					newSeating[idx][innerIdx] = 'L'
				elseif seat == 'L' and occCounter == 0 then
					newSeating[idx][innerIdx] = '#'
				else
					newSeating[idx][innerIdx] = seat
				end
			end
		end
	end

	return newSeating
end

function check_seating(seating1, seating2)
	for idx, row in ipairs(seating1) do
		for innerIdx, seat in ipairs(row) do
			if seating2[idx][innerIdx] ~= seat then return true end
		end
	end
	return false
end

for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	local seating = {{}}
	local idx, innerIdx = 1,1

	for char, space in string.gmatch(contents,"(.)(\n?)") do
		seating[idx][innerIdx] = char

		if space == '\n' then
			idx = idx + 1
			innerIdx = 1
			seating[idx] = {}
		else
			innerIdx = innerIdx + 1
		end
	end

	local didChange = true

	while didChange do
		local nextSeating = rotate_seating(seating)
		didChange = check_seating(seating, nextSeating)
		--show_seating(nextSeating)
		seating = nextSeating
	end 

	local answer = count_seats(seating,'#')

	print("For File:",file,"Answer is:",answer)
end
