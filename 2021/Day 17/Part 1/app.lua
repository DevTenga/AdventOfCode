-- Advent of Code: Day 17,Part 1
-- DevTenga
-- 17/12/2021

-- https://adventofcode.com/2021/day/17

for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	-- For this particular question (Part 1), we can
	-- ignore the x-axis and the top of the y-axis. 
	-- We only need the base of the z-axis. We can 
	-- project the probe straight down (Both sample
	-- and input are below y = 0 fortunately).
	-- This means our initial velocity would be the
	-- measure of the base - 1. (Accounting for the)
	-- 1+ velocity at the start position. The highest
	-- Y-position would just be the sum of all natural
	-- numbers from 1 to the y-base. 
	-- The formula: [s = n * (n + 1) / 2] accounts for 
	-- the change. 

	local y1,y2 = string.match(contents,"target area: x=%d+%.%.%-?%d+%, y%=(%-?%d+)%.%.(%-?%d+)")

	y1 = tonumber(y1)
	y2 = tonumber(y2)
	local yBase = math.min(y1, y2)
	print(yBase)
	local answer = yBase * (yBase + 1) / 2
	print("For File:",file,"Answer is:",answer)
end
