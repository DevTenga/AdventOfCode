-- Advent of Code: Day 23,Part 1
-- DevTenga
-- 14/01/2022

-- https://adventofcode.com/2021/day/23


local regex =  "%#%#+(%w)%#(%w)%#(%w)%#(%w)%#+"
			.. "%s+%#(%w)%#(%w)%#(%w)%#(%w)"

for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	local rooms = {}

	local game = {}

	function game.isComplete()
		for idx, char in ipairs {'A','B','C','D'} do
			if rooms[idx][1] ~= char or rooms[idx][2] ~= char then 
				return false 
			end
		end
		return true
	end

	function game.getInnerChatAtHome()
		for idx, char in ipairs {'A','B','C','D'} do
			if rooms[idx][2] == char then 
				return idx, char
			end
		end
	end

	function game.getCheapestMovementPair()
		
	end

	rooms[1][1],
	rooms[2][1] 
	rooms[3][1],
	rooms[4][1],
	rooms[1][2],
	rooms[2][2],
	rooms[3][2],
	rooms[4][2] 
	= string.match(contents,regex)



	local answer = 0

	print("For File:",file,"Answer is:",answer)
end
