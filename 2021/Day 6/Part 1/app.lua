-- Advent of Code: Day 6,Part 1
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
			for _,clock in ipairs(self) do
				str = str .. clock .. ","
			end
			str = str .. "\nNo of fish: "..#fish.."\n\n"
			return str
		end
	}

	setmetatable(fish,fish_mtt)

	for fishClock in string.gmatch(contents,"(%d+)") do
		fish[#fish + 1] = fishClock
	end

	local function step_day()
		local newFish = {}
		local newCounter = 1
		for idx,fishClock in ipairs(fish) do
			fishClock = fishClock - 1
			
			if fishClock == -1 then
				newFish[idx] = renewLife
				newFish[#fish + newCounter] = newLife
				newCounter = newCounter + 1
			else
				newFish[idx] = fishClock
			end
		end
		fish = setmetatable(newFish,fish_mtt)
		day = day + 1
	end

	local function get_status()
		print(fish)
	end

	get_status()

	for _ = 1,18 do
		step_day()
		--get_status()
	end

	print("================= 18 Over ================ ")

	for i = 19,80 do
		step_day()
		--get_status()
	end

	local answer = #fish

	print("For File:",file,"Answer is:",answer)
end
