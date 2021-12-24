-- Advent of Code: Day 4,Part 2
-- DevTenga
-- 04/12/2021

-- https://adventofcode.com/2021/day/4

function main(file, arg)
	local contents = io.open(file):read("*all")

	local inputs = {}
	local boards = {{{{val = 0,bool = false}}}}

	local boardInit = {
		n = 1,
		row = 1,
		column =1
	}

	local winningBoard = nil

	local completed = false

	local lastIn = 0

	function view_boards()
		for _,board in ipairs(boards) do
			for _,row in ipairs(board) do
				for _,column in ipairs(row) do
					io.stdout:write(column.bool and "\027[32m" or "\027[31m",string.format("%.2d",column.val or "-1"),"\027[0m"," ")
				end
				io.stdout:write("\n")
			end
			io.stdout:write("\n\n")
		end
	end

	local function checkIfWon()
		-- For each board
		for idx,board in ipairs(boards) do
			-- Column check
			for i = 1,#board do
				local toProceed = true
				for j = 1,#board do
					if not toProceed then break end
					if board[i][j].bool == false then toProceed = false end
				end
				if toProceed then 
					print("BOARD WON COLUMN::::::::::::",idx)
					view_boards()
					return idx 
				end 
			end

			-- Row Check
			for i = 1,#board do
				local toProceed = true
				for j = 1,#board[i] do
					if not toProceed then break end
					if board[j][i].bool == false then toProceed = false end
				end
				if toProceed then 
					print("BOARD WON ROW ::::::::::::")
					view_boards()
					return idx 
				end 
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

	print("Dirty BOARDS:")
	view_boards()

	--boards[boardInit.n] = nil
	boards[boardInit.n][boardInit.row][boardInit.column] = nil
	boards[1] = boards[#boards]
	boards[#boards] = nil

		
	local function boardTest(idx,input)
		print("CALLING:::",input)
		local completed = false
		for b,board in ipairs(boards) do
			for r,row in ipairs(board) do
				for c,column in ipairs(row) do
					if column.val == input then
					print("CANCELLED",column.val,i,r,c) 
						column.bool = true
						winningBoard = checkIfWon()
						print("WIN IDX:",winningBoard)
						if winningBoard then
							return true,board
						end
					end
				end
			end			
		end
	end

	print("CURRENT BOARDS:")
	view_boards()

	local sum = 0


	local idx = 1
	
	while idx <= #inputs and next(boards) and #boards > 0 do
		local input = inputs[idx]
		local didPass, board = boardTest(idx,input)

		if didPass then
			local n = #boards
			print("CURRENT BOARDS:")
			view_boards()
			lastIn = idx
			if #boards == 1 then winningBoard = boards[winningBoard] end
			boards[winningBoard] = boards[n]
			boards[n] = nil
		else
			idx = idx + 1
		end
	end

	print("SELECTION:", next(boards))
	
	for _,row in ipairs(winningBoard) do
		for _,column in ipairs(row) do
			if not column.bool then
				print(column.val) 
				sum = sum + column.val
			end
		end
	end

	lastIn = inputs[lastIn]

	sum = sum -- lastIn

	local answer = sum * lastIn
	return answer,sum,lastIn
end

local res = {}

for idx,file in ipairs(arg) do
	res[idx] = {file = file, arg = {main(file,arg)}}
end

for _,resel in ipairs(res) do  
	print("For File:",resel.file,"Answer is:",table.unpack(resel.arg))
end
