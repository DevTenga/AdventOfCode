-- Advent of Code: Day 2, Part 1
-- DevTenga
-- 02/12/2021

-- https://adventofcode.com/2021/day/2

for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	local sumbarine = {
		depth = 0,
		pos = 0,
	}

	local config = {
		forward = function (num)
			sumbarine.pos = sumbarine.pos + num
		end,

		down = function (num)
			sumbarine.depth = sumbarine.depth + num
		end,

		up = function (num)
			sumbarine.depth = sumbarine.depth - num
		end,

		get = function ()
			return sumbarine.pos * sumbarine.depth
		end
	}

	for cmd,val in string.gmatch(contents,"%s-(%w+)%s-(%d+)") do
		config[cmd](val)
	end

	local answer = config.get()

	print("For File:",file,"Answer is:",answer,sumbarine.depth,sumbarine.pos)
end
