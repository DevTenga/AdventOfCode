-- Advent of Code: Day 12,Part 1
-- DevTenga
-- 26/01/2022

-- https://adventofcode.com/2020/day/12

for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	local ship = {
		east = 0,
		north = 0,
		dir = 1
	}

	ship.dirCommand = {
		[0] = 'N',
		[1] = 'E',
		[2] = 'S',
		[3] = 'W'
	}

	-----------------------------------------------

	function ship.N(val)
		ship.north = ship.north + val
	end

	function ship.E(val)
		ship.east = ship.east + val
	end

	function ship.S(val)
		ship.north = ship.north - val
	end

	function ship.W(val)
		ship.east = ship.east - val
	end

	function ship.R(val)
		ship.dir = (ship.dir + val / 90) % 4
	end

	function ship.L(val)
		ship.dir = (ship.dir - val / 90) % 4
	end

	function ship.F(val)
		ship[ship.dirCommand[ship.dir]](val)
	end
	-----------------------------------------------

	for cmd, val in string.gmatch(contents,"(%w)(%d+)") do
		ship[cmd](tonumber(val))
		-- Debugging
		-- print("Called: "..cmd..val, "East: "..ship.east, "North: "..ship.north)
	end

	local answer = math.abs(ship.north) + math.abs(ship.east)

	print("For File:",file,"Answer is:",answer)
end
