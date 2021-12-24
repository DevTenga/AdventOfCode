-- Advent of Code: Day 11,Part 2
-- DevTenga
-- 11/12/2021

-- https://adventofcode.com/2021/day/11

for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	local base = 10
	local steps = 0

	local octopi = {}
	local syncStep = nil

	for octopus in string.gmatch(contents,"(%d)") do
		octopi[#octopi + 1] = {oc = octopus, flashed = false}
	end

	print("OCPI:",  #octopi)

	local function test_flashes(flashTable)
		local nextFlashTable = {}
		for _,idx in ipairs(flashTable) do
			if octopi[idx] and octopi[idx].oc > 9 then
				octopi[idx] = {oc = 0, flashed = true}
				local nextLen = #nextFlashTable

				local elTable

				if (idx - 1) % base == 0 then
					elTable = {
						idx - base,
						idx - base + 1,
						idx + 1,
						idx + base,
						idx + base + 1
					} 
				elseif idx % base == 0 then
					elTable = {
						idx - base - 1,
						idx - base,
						idx - 1,
						idx + base - 1,
						idx + base
					}
				else
					elTable = {
						idx - base - 1, 
						idx - base,
						idx - base + 1, 
						idx - 1,
						idx + 1, 
						idx + base - 1, 
						idx + base, 
						idx + base + 1
					}
				end

				for nIdx,sIdx in ipairs(elTable) do
					if octopi[sIdx] and not octopi[sIdx].flashed then
						octopi[sIdx] = {oc = octopi[sIdx].oc + 1, false}
					end
					nextFlashTable[nextLen + nIdx] = sIdx
				end
			end
		end

		if next(nextFlashTable) then
			test_flashes(nextFlashTable)
		end

	end
	
	local function view_octopi()
		local nlCounter = 1
		for i = 1,#octopi do
			
			if octopi[i].flashed then
				io.stdout:write("\027[31m",octopi[i].oc,"\027[0m")
			else
				io.stdout:write("\027[0m",octopi[i].oc,"\027[0m") 
			end

			if nlCounter == base then
				io.stdout:write("\n")
				nlCounter = 1 
			else
				nlCounter = nlCounter + 1
			end

		end

		io.stdout:write("\n\n")
	end

	local function step()
		view_octopi()
		local flashTable = {}
		local didSync = true

		for i = 1,#octopi do
			if octopi[i] and not octopi[i].flashed then
				didSync = false
			end
			flashTable[#flashTable + 1] = i
			octopi[i] = {oc = octopi[i].oc + 1, flashed = false}
		end

		if didSync then
			syncStep = steps
			return 
		end
		
		steps = steps + 1

		test_flashes(flashTable)
	end

	repeat
		step()
	until syncStep

	view_octopi()

	local answer = syncStep

	print("For File:",file,"Answer is:",answer)
end
