-- Advent of Code: Day 4,Part 1
-- DevTenga
-- 11/01/2021

-- https://adventofcode.com/2020/day/4

-- ========================== Table Utilities ========================== --

function table_deepPrint(t,tabCount,_isRecursive)
	tabCount = tabCount or 0
	if not _isRecursive then print("\n\n======================\n\n") end
	if not _isRecursive then print(string.rep("\t",tabCount).."{") end
	for k,v in next,t do
		if type(v) ~= "table" then
			print(string.rep("\t",tabCount + 1)..'['..k..'] = '..v..",")
		else
			print(string.rep("\t",tabCount + 1)..'['..k..'] = {')
			table_deepPrint(v,tabCount + 1,true)
		end
	end
	print(string.rep("\t",tabCount).."}")
end

-- ============================ Code Flow ============================== --

for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	local passports = {}
	local currentPassport = {}

	for k,v,space in string.gmatch(contents,"(%w+)%:([%#%w]+)(%s*)") do
		currentPassport[k] = v
		if string.match(space,"\n\n") then
			passports[#passports + 1] = currentPassport
			currentPassport = {}
		end
	end

	passports[#passports + 1] = currentPassport

	local function isPassportValid(passport, fields)
		for _,key in ipairs(fields) do
			if not passport[key] then return false end
		end
		return true
	end

	local requiredFields = {
		"byr",
		"iyr",
		"eyr",
		"hgt",
		"hcl",
		"ecl",
		"pid"
	}
	
	local answer = 0

	-- Debugging
	--table_deepPrint(passports)

	for _,passport in ipairs(passports) do
		if isPassportValid(passport, requiredFields) then
			answer = answer + 1
		end
	end

	print("For File:",file,"Answer is:",answer)
end
