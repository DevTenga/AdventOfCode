-- Advent of Code: Day 13,Part 2
-- DevTenga
-- 27/01/2022

-- https://adventofcode.com/2020/day/13

for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	local idx, t = 0, {}

	for bID in string.gmatch(contents,"(%w+)%,") do
		-- Ignore x for part 1.
		t[idx] = tonumber(bID)
		idx = idx + 1
	end

	local bID = tonumber(string.match(contents,"(%w+)$"))
	t[idx] = bID or 1

	local function check_num(num)
		for idx, val in next, t do
			if (num + idx) % val ~= 0 then return false end
		end 
		return true
	end

	local mul = 1
	local val = t[0]
	local answer

	-- Apply the constraint.
	if string.match(file,"input%.txt") then
		mul = math.floor(100000000000000 / val)
	end

	-- Debugging
	-- for k,v in next, t do print(k,v) end

	while not answer do
		--print(mul)
		local num = val * mul
		if check_num(num) then
			answer = num
		else
			mul = mul + 1
		end
	end

	
	print("For File:",file,"Answer is:",answer)
end
