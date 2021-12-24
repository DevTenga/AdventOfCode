-- Advent of Code: Day 10,Part 1
-- DevTenga
-- 10/12/2021

-- https://adventofcode.com/2021/day/10

for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	local nextClosers = {}
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
		[")"] = 3, 
		["]"] = 57,
		["}"] = 1197,
		[">"] = 25137
	}

	local starter = "[%(%[%<%{]"
	local ender = "[%)%]%}%>]"

	local n = 0
	for chunk in string.gmatch(contents,"[%[%{%(%<%]%}%)%>]+\n*") do
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
				break 
			end
		end
	end

	local answer = 0

	for closer,count in pairs(errors) do
		answer = answer + errorPrices[closer] * count
	end

	print("For File:",file,"Answer is:",answer)
end
