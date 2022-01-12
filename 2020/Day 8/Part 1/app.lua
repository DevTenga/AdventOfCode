-- Advent of Code: Day 8,Part 1
-- DevTenga
-- 12/01/2022

-- https://adventofcode.com/2020/day/8

for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	local boot = {}
	boot.__accumulator = 0
	boot.__idx = 1
	boot.__instructions = {}

	function boot.acc(val)
		boot.__accumulator = boot.__accumulator + val
		boot.jmp(1)
		return boot.__accumulator
	end

	function boot.jmp(idx)
		boot.__idx = boot.__idx + idx
		return boot.__idx
	end

	function boot.nop(_)
		boot.jmp(1)
		return
	end

	function boot.hasRun()
		return boot.__instructions[boot.__idx].hasRun
	end

	function boot.run(idx, ...)
		idx = idx or boot.__idx
		local bootObj = boot.__instructions[idx]
		bootObj.hasRun = true
		return boot[bootObj.cmd](bootObj.val)
	end

	for cmd, val in string.gmatch(contents,"(%w+)%s+([%+%-]?%d+)") do
		val = tonumber(val)
		boot.__instructions[boot.__idx] = {cmd = cmd, val = val, hasRun = false}
		boot.jmp(1)
	end

	boot.__idx = 1

	while not boot.hasRun() do
		boot.run()
	end

	local answer = boot.__accumulator

	print("For File:",file,"Answer is:",answer)
end
