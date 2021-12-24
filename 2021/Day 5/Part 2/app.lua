-- Advent of Code: Day 5,Part 2
-- DevTenga
-- 05/12/2021

-- https://adventofcode.com/2021/day/5


for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	local plane = {{}}


	local function view_plane()
		local pointerX = 0

		for i = 0,#plane do
			Xaxis = plane[i]
			for j = 0,#Xaxis do
				local unit = Xaxis[j]

				if unit and unit > 0 then
					io.stdout:write(unit)
					pointerX = pointerX + 1
				else
					io.stdout:write "."
					pointerX = pointerX + 1
				end
			end

			while pointerX < 15 do
				io.stdout:write "."
				pointerX = pointerX + 1
			end			
			pointerX = 0

			io.stdout:write "\n"
		end

		io.stdout:write "\n\n"
	end

	local lastY = 0 

	for x1,y1,x2,y2 in string.gmatch(contents,"(%d+),(%d+)%s*->%s*(%d+),(%d+)") do
		x1 = tonumber(x1)
		x2 = tonumber(x2)
		y1 = tonumber(y1)
		y2 = tonumber(y2)

		if y1 == y2 then
			print("X AT",string.format("%d,%d -> %d,%d",x1,y1,x2,y2))
			for x = math.min(x1, x2), math.max(x1, x2) do
				while lastY <= y1 do
					plane[lastY] = {}
					lastY = lastY + 1
				end

				for n = 0, x do
					if not plane[y1][n] then
						plane[y1][n] = 0
					end
				end

				plane[y1][x] = plane[y1][x] and plane[y1][x] + 1 or 1
				--view_plane()
			end
		elseif x1 == x2 then
			print("Y AT",string.format("%d,%d -> %d,%d",x1,y1,x2,y2))
			for y = math.min(y1, y2), math.max(y1, y2) do

				while lastY <= y do
					plane[lastY] = {}
					lastY = lastY + 1
				end

				for n = 0, x1 do
					if not plane[y][n] then
						plane[y][n] = 0
					end
				end

				plane[y][x1] = plane[y][x1] and plane[y][x1] + 1 or 1
				--view_plane()
			end
		else
			print("BOTH AT",string.format("%d,%d -> %d,%d",x1,y1,x2,y2))
			local xSign = x2 - x1 < 0 and -1 or 1
			local ySign = y2 - y1 < 0 and -1 or 1

			local x = x1
			local y = y1

			while x ~= x2 and y ~= y2 do
				while lastY <= y do
					plane[lastY] = {}
					lastY = lastY + 1
				end

				for n = 0, x do
					if not plane[y][n] then
						plane[y][n] = 0
					end
				end

				plane[y][x] = plane[y][x] and plane[y][x] + 1 or 1
				x = x + xSign
				y = y + ySign
			end
			print("LAST BIT:",y2,x2)
			plane[y2][x2] = plane[y2][x2] and plane[y2][x2] + 1 or 1
			--view_plane()
		end

	end

	local answer = 0

	for _,Xaxis in next,plane do
		for _,unit in next,Xaxis do 
			if unit >= 2 then
				answer = answer + 1
			end
		end
	end

	print(plane[8][8])

	view_plane()

	print("For File:",file,"Answer is:",answer)
end
