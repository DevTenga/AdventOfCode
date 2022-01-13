-- Advent of Code: Day 10,Part 2
-- DevTenga
-- 13/01/2022

-- https://adventofcode.com/2020/day/10

function fact(n)
	local p = 1
	--print("::",n)
	for m = n,1,-1 do
		--print(m)
		p = p * m 
	end
	return p
end

for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	local jolts = {0}

	local jolts_3, jolts_1 = 0,0
	local idx = 2

	for jolt in string.gmatch(contents,"(%d+)\n") do
		jolts[idx] = tonumber(jolt)
		idx = idx + 1
	end

	jolts[idx] = tonumber(string.match(contents,"(%d+)$"))

	table.sort(jolts)
	jolts[idx + 1] = jolts[idx] + 3

	local possibilityCounters = {}
	local currentPossibilityCounter = 1
	local pDigits = 0
	local foundPossibility = false

	for idx, jolt in ipairs(jolts) do

		-- Debugging
		-- print(jolt)

		foundPossibility = false

		local _,nextJolt = next(jolts, idx + 1)
		local _,fartherJolt = next(jolts, idx + 2)

		if nextJolt and nextJolt - jolt <= 3 then
			currentPossibilityCounter = currentPossibilityCounter + 1
			foundPossibility = true
			pDigits = pDigits + 1
		end

		if fartherJolt and fartherJolt - jolt <= 3 then
			currentPossibilityCounter = currentPossibilityCounter + 1
			foundPossibility = true
		end

		if not foundPossibility then
			if currentPossibilityCounter > 1 then
				pDigits = currentPossibilityCounter > 4 and pDigits or 0
				possibilityCounters[#possibilityCounters + 1] = currentPossibilityCounter + math.floor(pDigits/2)
			end
			currentPossibilityCounter = 1
			pDigits = 0
		end
	end

	local answer = 1

	for _,possibility in ipairs(possibilityCounters) do
		answer = answer * possibility
	end

	print("For File:",file,"Answer is:",answer, jolts_1, jolts_3)
end
