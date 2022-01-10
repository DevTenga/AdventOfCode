-- Advent of Code: Day 21,Part 1
-- DevTenga
-- 21/12/2021

-- https://adventofcode.com/2021/day/21

for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	local players = {}
	local diceAt = 1

	for player,pos in string.gmatch(contents,"[%w%s]-(%d+)[%w%s]-%:%s-(%d+)") do
		players[tonumber(player)] = {idx = tonumber(player), pos = tonumber(pos), score = 0}	
	end

	local currentPlayer = {score = 0} -- placeholder 

	while currentPlayer.score < 1000 do
		if currentPlayer and currentPlayer.pos then
			currentPlayer = players[currentPlayer.idx + 1] or players[1]
		else
			currentPlayer = players[1]
		end

		local lastPos = currentPlayer and currentPlayer.pos
		lastPos = lastPos + 3 * diceAt + 3
		lastPos = lastPos % 10
		lastPos = lastPos == 0 and 10 or lastPos
		diceAt = diceAt + 3

		currentPlayer.score = currentPlayer.score + lastPos
		currentPlayer.pos = lastPos
	end

	currentPlayer.isWinner = true
	diceAt = diceAt - 1

	local answer = 0

	for _,player in ipairs(players) do
		if not player.isWinner then
			answer = answer + player.score * diceAt
		end
	end

	print("For File:",file,"Answer is:",answer)
end
