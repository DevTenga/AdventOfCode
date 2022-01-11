-- Advent of Code: Day 2,Part 1
-- DevTenga
-- 02/12/2021

-- https://adventofcode.com/2021/day/2

for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")
	local answer = 0

	for min,max,letter,pass in string.gmatch(contents,"(%d+)%-(%d+)%s*(%w)%:%s*(%w+)") do
		local _,count = string.gsub(pass,letter,"")
		if count >= tonumber(min) and count <= tonumber(max) then answer = answer + 1 end
	end

	print("For File:",file,"Answer is:",answer)
end
