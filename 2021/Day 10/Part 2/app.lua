-- Advent of Code: Day 10,Part 2
-- DevTenga
-- 10/12/2021

-- https://adventofcode.com/2021/day/10

for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	local nextClosers = {}
	local scores = {}
	
	local chunkPairs = {
		["("] = ")", 
		["["] = "]",
		["{"] = "}",
		["<"] = ">"
	}

	local errors = {
		[")"] = 0, 
		["]"] = 0,
		["}"] = 0,
		[">"] = 0
	}

	local errorPrices = {
		[")"] = 1, 
		["]"] = 2,
		["}"] = 3,
		[">"] = 4
	}

	local starter = "[%(%[%<%{]"
	local ender = "[%)%]%}%>]"

	local n = 0
	for chunk in string.gmatch(contents,"[%[%{%(%<%]%}%)%>]+\n*") do
		nextClosers = {}
		local didError = false
		n = n + 1

		for i = 1,#chunk do
			local char = string.sub(chunk,i,i)
			if string.match(char,starter) then
				nextClosers[#nextClosers + 1] = chunkPairs[char]
			elseif string.match(char,ender) and nextClosers[#nextClosers] == char then
				nextClosers[#nextClosers] = nil	
				
			elseif string.match(char,ender) and nextClosers[#nextClosers] ~= char then
				print("AT LINE:",n,"AT CHAR:",i,"EXPECTED",nextClosers[#nextClosers],"GOT",char)
				errors[char] = errors[char] + 1
				didError = true
				break 
			end
		end

		if not didError then
			local score = 0
			for i = #nextClosers,1,-1 do
				score = score * 5 + errorPrices[nextClosers[i]]
			end

			scores[#scores + 1] = score
			print("\027[31mFOR LINE:",n,"SCORE IS:",score,"\027[0m")
		end
	end

	table.sort(scores)

	for _,score in ipairs(scores) do 
		print("\t\027[35m",score,"\027[0m") 
	end

	local answer = scores[(#scores + 1) / 2]

	print("For File:",file,"Answer is:",answer)
end
