-- Advent of Code: Day 8,Part 2
-- DevTenga
-- 12/01/2022

-- https://adventofcode.com/2020/day/8

for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	local boot = {}
	boot.__accumulator = 0
	boot.__idx = 1
	boot.__visited = {}

	boot.__instructions = {}
	boot.__nil = {}
	boot.__jumps = {}

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
		local bootObj = boot.__instructions[boot.__idx]
		return not bootObj or bootObj.hasRun
	end

	function boot.didEnd()
		return boot.__idx > #boot.__instructions
	end 

	function boot.run(idx, cmd)
		idx = idx or boot.__idx
		local bootObj = boot.__instructions[idx]
		cmd = cmd or bootObj.cmd
		
		bootObj.hasRun = true
		boot.__visited[#boot.__visited + 1] = bootObj
		return boot[cmd](bootObj.val)
	end

	function boot.reset()
		for _,bootObj in ipairs(boot.__visited) do
			bootObj.hasRun = false
		end
		boot.__visited = {}
		boot.__accumulator = 0
		boot.__idx = 1
	end

	for cmd, val in string.gmatch(contents,"(%w+)%s+([%+%-]?%d+)") do
		val = tonumber(val)

		local idx = boot.__idx
		local jumps = boot.__jumps
		local nops = boot.__nil

		if cmd == "jmp" then
			jumps[#jumps + 1] = idx
		elseif cmd == "nop" then
			nops[#nops + 1] = idx
		end

		boot.__instructions[idx] = {cmd = cmd, val = val, hasRun = false}
		boot.jmp(1)
	end

	boot.__idx = 1

	local function test_cmd(idx,cmd)
		while not boot.hasRun() do
			if boot.__idx == idx then 
				boot.run(nil, cmd)
			else
				boot.run()
			end
		end
		local didEnd = boot.didEnd()
		if not didEnd then boot.reset() end
		return didEnd
	end

	local answer = nil

	for _, bootIdx in ipairs(boot.__jumps) do
		if test_cmd(bootIdx,"nop") then
			answer = boot.__accumulator
			break
		end
	end

	if not answer then
		for _, bootIdx in ipairs(boot.__nil) do
			if test_cmd(bootIdx,"jmp") then
				answer = boot.__accumulator
				break
			end
		end
	end

	print("For File:",file,"Answer is:",answer)
end
