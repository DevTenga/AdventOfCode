-- Advent of Code: Day 12,Part 2
-- DevTenga
-- 26/01/2022

-- https://adventofcode.com/2020/day/12

for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	local waypoint = {
		east = 10,
		north = 1,
		dir = 1
	}

	local ship = {
		east = 0,
		north = 0
	}

	waypoint.dirCommand = {
		[0] = {1,1},
		[1] = {-1,1},
		[2] = {-1,-1},
		[3] = {1,-1}
	}

	-----------------------------------------------

	function waypoint.N(val)
		waypoint.north = waypoint.north + val
	end

	function waypoint.E(val)
		waypoint.east = waypoint.east + val
	end

	function waypoint.S(val)
		waypoint.north = waypoint.north - val
	end

	function waypoint.W(val)
		waypoint.east = waypoint.east - val
	end

	function waypoint.R(val)
		local east = waypoint.east
		local north = waypoint.north

		for _ = 1, (val / 90) % 4 do
			waypoint.east = north
			waypoint.north = -east
			east = waypoint.east
			north = waypoint.north
		end

	end

	function waypoint.L(val)
		local east = waypoint.east
		local north = waypoint.north

		for _ = 1, (val / 90) % 4 do
			waypoint.east = -north
			waypoint.north = east
			east = waypoint.east
			north = waypoint.north
		end

	end

	function waypoint.F(val)
		ship.north = ship.north + waypoint.north * val
		ship.east = ship.east + waypoint.east * val 
	end
	-----------------------------------------------

	for cmd, val in string.gmatch(contents,"(%w)(%d+)") do
		waypoint[cmd](tonumber(val))
		-- Debugging
		print("Called: "..cmd..val)
		print("SHIP: \n\tEast: "..ship.east, "North: "..ship.north)
		print("\nWAYPOINT: \n\tEast: "..waypoint.east, "North: "..waypoint.north)
		print("----------------------\n")
	end

	local answer = math.abs(ship.north) + math.abs(ship.east)

	print("For File:",file,"Answer is:",answer)
end
