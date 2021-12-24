-- Advent of Code: Day 4,Part 1
-- DevTenga
-- 04/12/2021

-- https://adventofcode.com/2021/day/4

for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	local inputs = {}
	local boards = {{{{val = 0,bool = false}}}}

	local boardInit = {
		n = 1,
		row = 1,
		column =1
	}

	local winningBoard = {}

	local completed = false

	local lastIn = 0

	local function checkIfWon()
		-- For each board
		for _,board in ipairs(boards) do
			-- Column check
			for i = 1,#board do
				local toProceed = true
				for j = 1,#board[i] do
					if not toProceed then break end
					if board[i][j].bool == false then toProceed = false end
				end
				if toProceed then return board end 
			end

			-- Row Check
			for i = 1,#board do
				local toProceed = true
				for j = 1,#board[i] do
					if not toProceed then break end
					if board[j][i].bool == false then toProceed = false end
				end
				if toProceed then return board end 
			end
		end
	end

	for num1, num2 in string.gmatch(contents,"(%d*),(%d+)") do
		if inputs[#inputs] ~= num1 then
			inputs[#inputs + 1] = tonumber(num1)
		end
		inputs[#inputs + 1] = tonumber(num2)
	end

	for comma,num,comma2,space in string.gmatch(contents,"(,*)(%d+)(,*)(%s*)") do
		if not string.match(comma,",") and not string.match(comma2,",") then
			local toAppend = false
			local n,row,column = boardInit.n, boardInit.row, boardInit.column
			if string.match(space,"\n\n") then
				toAppend = true
				boardInit.n = boardInit.n + 1
				boardInit.row = 1
				boardInit.column = 1
				boards[boardInit.n] = {}
				boards[boardInit.n][1] = {}
				boards[boardInit.n][1][1] = {}

			elseif string.match(space,"\n") then
				toAppend = true
				boardInit.row = boardInit.row + 1
				boardInit.column = 1
				boards[boardInit.n][boardInit.row] = {}
				boards[boardInit.n][boardInit.row][1] = {}

			elseif not string.match(space,"[%s,]") or string.match(space," ") then
				toAppend = true
				boardInit.column = boardInit.column + 1
				boards[boardInit.n][boardInit.row][boardInit.column] = {}
			end

			if toAppend and tonumber(num) then
				boards[n][row][column].val = tonumber(num)
				boards[n][row][column].bool = false
			end
		end
	end

	-- Cleanup
	boards[boardInit.n][boardInit.row][boardInit.column] = nil

	for _,input in ipairs(inputs) do
		for _,board in ipairs(boards) do
			for _,row in ipairs(board) do
				for _,column in ipairs(row) do
				
					if column.val == input then 
						column.bool = true
						winningBoard = checkIfWon()
						if winningBoard then
							lastIn = input 
							completed = true 
							break
						end
					end

				end
				if completed then break end
			end
			if completed then break end
		end
		if completed then break end
	end

	local sum = 0

	for _,row in ipairs(winningBoard) do
		for _,column in ipairs(row) do
			if not column.bool then 
				sum = sum + column.val
			end
		end
	end

	local answer = sum * lastIn

	print("For File:",file,"Answer is:",answer,sum,lastIn)
end
