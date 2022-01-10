-- Advent of Code: Day 21,Part 2
-- DevTenga
-- 21/12/2021

-- https://adventofcode.com/2021/day/21

-- ========================== Table Utilities ========================== --

function table_deepPrint(t,tabCount,_isRecursive)
	tabCount = tabCount or 0
	if not _isRecursive then print(string.rep("\t",tabCount).."{") end
	for k,v in next,t do
		if type(v) ~= "table" then
			print(string.rep("\t",tabCount + 1)..'['..k..'] = '..v..",")
		else
			print(string.rep("\t",tabCount + 1)..'['..k..'] = {')
			table_deepPrint(v,tabCount + 1,true)
		end
	end
	print(string.rep("\t",tabCount).."}")
	if not _isRecursive then print("\n\n======================\n\n") end
end

function table_join( parent, ... )
	parent = parent or {}
	for _,t in ipairs {...} do
		for k,v in next, t do
			parent[k] = parent[k] and parent[k] + v or v
		end
	end
	return parent
end

-- ========================== Core Functions =========================== --

local function combine(t,depth,add)
	add = add or 0
	depth = depth or 1
	local _t = {}

	if depth >= #t then
		for _, val in ipairs(t) do
			_t[#_t + 1] = val + add
		end
	else
		for _, val in ipairs(t) do
			local collection = combine(t, depth + 1, val + add)
			table.move(collection, 1, #collection, #_t + 1, _t)
		end
	end

	return _t
end

-- ============================ Code Flow ============================== --

for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	local posn = {}
	local mem = {}
	local rolls = combine {1,2,3}

	for player,pos in string.gmatch(contents,"[%w%s]-(%d+)[%w%s]-%:%s-(%d+)") do
		posn[tonumber(player)] = tonumber(pos)	
	end

	-- Debugging
	--[[
	print(#combine {1,2,3})
	for idx,val in next, combine {1,2,3} do print(val) end
	]]

	local function roll_dice(lastPosP1, lastPosP2, lastScoreP1, lastScoreP2)
		lastScoreP1 = lastScoreP1 or 0
		lastScoreP2 = lastScoreP2 or 0

		local memIdx = "P1 -> pos: "..lastPosP1
			..", score: "..lastScoreP1
			.."; P2 -> pos: "..lastPosP2
			..", score: "..lastScoreP2

		local memVal = mem[memIdx]
		
		-- Found a memoized value? Return that. 
		if memVal then
			-- Debugging
			--[[
			print("Found memVal for", memIdx)
			table_deepPrint(memVal)
			--]]
			return memVal
		end

		local wins = {0,0}

		-- Player 1 rolls (thrice is accounted for):
		for _,rollP1 in next, rolls do
			local posP1 = (lastPosP1 + rollP1) % 10
			posP1 = posP1 == 0 and 10 or posP1

			local scoreP1 = lastScoreP1 + posP1

			-- Player 1 wins. Create no new universes.
			if scoreP1 >= 21 then
				wins[1] = wins[1] + 1
			else
				-- Player 2 rolls (thrice is accounted for):
				for _,rollP2 in next, rolls do
					--print("P1:",rollP1)
					local posP2 = (lastPosP2 + rollP2) % 10
					posP2 = posP2 == 0 and 10 or posP2

					local scoreP2 = lastScoreP2 + posP2

					-- Player 2 wins. Create no new universes.
					if scoreP2 >= 21 then
						wins[2] = wins[2] + 1
					else
						-- Create a new set of universes.
						local innerWins = roll_dice(posP1, posP2, scoreP1, scoreP2)
						table_join(wins,innerWins)
					end

				end
			end
		end

		-- Store the current wins for memoization logic.
		mem[memIdx] = wins
		return wins
	end

	local scoreP1, scoreP2 = table.unpack(roll_dice(posn[1], posn[2]))

	local answer = math.max(scoreP1, scoreP2)

	-- Debugging
	print("P1 -> "..scoreP1,"P2 -> "..scoreP2)

	print("For File:",file,"Answer is:",answer)
end
