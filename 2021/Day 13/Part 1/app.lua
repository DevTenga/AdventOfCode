-- Advent of Code: Day 13,Part 1
-- DevTenga
-- 13/12/2021

-- https://adventofcode.com/2021/day/13

for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	local base = 10

	local output = {}

	local function fold_up(crease)
		local counter = 0
		for i = #output, crease, -1 do
			
			for idx = 0,#output[i] do 
				if output[i][idx] == "#" then
					output[counter][idx] = "#"
				end
			end

			counter = counter + 1
			output[i] = nil
		end
	end

	local function fold_left(crease)
		for i = #output, 0, -1 do
			for idx = #output[i],crease,-1 do 
				if output[i][idx] == "#" then
					output[i][2 * crease - idx] = "#"
				end
				output[i][idx] = "."
			end
		end
	end

	local function view_pages()
		for i = 0,#output do 
			for j = 0, #output[i] do 
				io.stdout:write(output[i][j] or ".")
			end 
			io.stdout:write("\n") 
		end
		io.stdout:write("\n==========\n")	
	end

	local function count_pages()
		local counter = 0
		for i = 0,#output do 
			for j = 0, #output[i] do 
				if output[i][j] == "#" then counter = counter + 1 end
			end 
		end
		return counter	
	end

	local points = {}

	for x,y in string.gmatch(contents,"(%d+),(%d+)") do
		x = tonumber(x)
		y = tonumber(y)

		if x > base then base = x end
		points[#points + 1] = {x = x,y = y}
	end

	for _,point in ipairs(points) do
		local x = point.x
		local y = point.y

		for i = 0, y do
			if not output[i] then 
				local t = {}
				for i = 0, base do
					t[i] = "." 
				end

				output[i] = t 
			end
		end

		output[y][x] = "#"
	end



	view_pages()

	local loopCounter = 1

	for axis,val in string.gmatch(contents,"fold%s*along%s*(%w)%s*=%s*(%d+)") do
		val = tonumber(val)

		if loopCounter >= 2 then break end

		if axis == "y" then
			fold_up(val)
			view_pages()
		elseif axis == "x" then
			fold_left(val)
			view_pages()
		end
		loopCounter = loopCounter + 1
	end

	local answer = count_pages()

	print("For File:",file,"Answer is:",answer)
end
