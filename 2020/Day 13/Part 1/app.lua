-- Advent of Code: Day 13,Part 1
-- DevTenga
-- 27/01/2022

-- https://adventofcode.com/2020/day/13

for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	local wait = tonumber(string.match(contents, "(%d+)\n"))
	local timeMin, timeMinID = math.huge, math.huge

	for bID in string.gmatch(contents,"(%d+)%,") do
		-- Ignore x for part 1.
		bID = tonumber(bID)
		if bID then 
			local timeWait = (math.floor(wait / bID) + 1) * bID - wait
			if timeWait < timeMin then
				timeMin = timeWait
				timeMinID = bID
			end
		end
	end

	local bID = tonumber(string.match(contents,"(%d+)$"))
	if bID then 
		local timeWait = (math.floor(wait / bID) + 1) * bID - wait
		if timeWait < timeMin then
			timeMin = timeWait
			timeMinID = bID
		end
	end
	
	local answer = timeMinID * timeMin
	print("For File:",file,"Answer is:",answer)
end
