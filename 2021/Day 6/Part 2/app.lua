-- Advent of Code: Day 6,Part 2
-- DevTenga
-- 06/12/2021

-- https://adventofcode.com/2021/day/6

for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	local fish = {}

	local renewLife = 6
	local newLife = 8
	local day = 0

	local fish_mtt = {
		__tostring = function (self)
			local str = "After Day " .. day..", Fish At:"
			for idx = 0,8 do 
				local clock = self[idx]
				str = str .. "\n\t(Idx): "..idx.."(Clock) :"..clock .. ","
			end

			str = str .. "\nNo of fish: "..#fish.."\n\n"
			return str
		end,


		__len = function(self)
			local sum = 0
			for i = 0,8 do
				sum = sum + self[i]
			end
			return sum
		end

	}

	--setmetatable(fish,fish_mtt)

	for i = 0,8 do fish[i] = 0 end

	for fishClock in string.gmatch(contents,"(%d+)") do
		fishClock = tonumber(fishClock)
		fish[fishClock] = fish[fishClock] + 1
	end

	local function get_status()
		print(setmetatable(fish,fish_mtt))
	end

	local function step_days(count)
		while day <= count do
			get_status()
			local newGen = fish[0]
			
			for i = 0,7 do
				fish[i] = fish[i + 1] or 0
			end

			fish[8] = newGen
			fish[6] = fish[6] + newGen
			day = day + 1
		end
	end

	--get_status()

	step_days(256)

	local answer = #fish

	print("For File:",file,"Answer is:",answer)
end
