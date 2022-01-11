-- Advent of Code: Day 2,Part 2
-- DevTenga
-- 02/12/2021

-- https://adventofcode.com/2021/day/2

for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")
	local answer = 0

	for pos1,pos2,letter,pass in string.gmatch(contents,"(%d+)%-(%d+)%s*(%w)%:%s*(%w+)") do
		pos1 = tonumber(pos1)
		pos2 = tonumber(pos2)

		local isInPos1 = string.sub(pass,pos1,pos1) == letter
		local isInPos2 = string.sub(pass,pos2,pos2) == letter

		if not (isInPos1 and isInPos2) and (isInPos1 or isInPos2) then
			answer = answer + 1
		end
	end

	print("For File:",file,"Answer is:",answer)
end
