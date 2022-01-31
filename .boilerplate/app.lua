-- Advent of Code: Day {day}, Part {part}
-- DevTenga
-- {date}

-- https://adventofcode.com/{dir}/day/{day}

local answers = {}

for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	for _ in string.gmatch(contents,"regex") do
		
	end

	local answer = 0

	answers[file]= answer
end

print[[

================================================================
================================================================
]]

for file,answer in answers do
	print("For File:",file,"Answer is:",answer)
end