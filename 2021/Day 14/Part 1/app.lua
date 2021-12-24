-- Advent of Code: Day 14,Part 1
-- DevTenga
-- 14/12/2021

-- https://adventofcode.com/2021/day/14

for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	local insertions = {}

	local function append_str(str)
		local newStr = ""
		for i = 1, #str do
			local char = string.sub(str,i,i)
			local nextChar = string.sub(str, i+1, i+1)
			local insertion = nextChar and insertions[char .. nextChar]
			newStr = newStr .. char

			if insertion then
				newStr = newStr .. insertion
			end
		end
		return newStr
	end

	local mainStr = string.match(contents,"(%w+)\n\n")
	for letters,insertion in string.gmatch(contents,"(%w+)%s*->%s*(%w+)") do
		insertions[letters] = insertion
	end
	
	for i = 1,10 do
		mainStr = append_str(mainStr)
	end

	local min, max = math.huge,0

	local charMap = {}

	for i = 1,#mainStr do
		local char = string.sub(mainStr,i,i)
		
		if charMap[char] then
			charMap[char] = charMap[char] + 1
		else
			charMap[char] = 1
		end
	end

	local charArr = {}

	for _,val in pairs(charMap) do
		charArr[#charArr + 1] = val 
	end

	print(mainStr)

	local answer = math.max(table.unpack(charArr)) - math.min(table.unpack(charArr))

	print("For File:",file,"Answer is:",answer)
end
