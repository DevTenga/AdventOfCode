-- Advent of Code: Day 4,Part 2
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

local function table_find(t,v)
	for idx = 0, #t do
		val = t[idx]
		if v == val then return idx end
	end
end


-- ========================== Core Functions =========================== --
local function isPassportValid(passport, fields, eyeColors, toDebug)
	-- Check if all reqiured fields exist.
	for _,key in ipairs(fields) do
		if not passport[key] then
			if toDebug then print("\027[31m".."Failed at Field:",key.."\027[0m") end
			return false 
		end
	end

	-- Check birth year range: 1920 to 2002.
	local birthYear = tonumber(passport["byr"])
	if not birthYear or birthYear < 1920 or birthYear > 2002 then
		if toDebug then print("\027[31m".."Failed at BirthYear:",birthYear.."\027[0m") end
		return false
	end

	-- Check issue year range: 2010 to 2020.
	local issueYear = tonumber(passport["iyr"])
	if not issueYear or issueYear < 2010 or issueYear > 2020 then
		if toDebug then print("\027[31m".."Failed at IssueYear:",issueYear.."\027[0m") end
		return false
	end

	-- Check expiration year range: 2020 to 2030.
	local expYear = tonumber(passport["eyr"])
	if not expYear or expYear < 2020 or expYear > 2030 then
		if toDebug then print("\027[31m".."Failed at expYear:",expYear.."\027[0m") end
		return false
	end

	-- Check height range: 150cm to 193cm OR 59in to 76in.
	local height,scale = string.match(passport["hgt"],"(%d+)(%w+)")
	height = tonumber(height)
	if scale == "cm" then
		if height < 150 or height > 193 then
			if toDebug then print("\027[31m".."Failed at Height:",height..scale.."\027[0m") end
			return false
		end
	elseif scale == "in" then
		if height < 59 or height > 76 then
			if toDebug then print("\027[31m".."Failed at Height:",height..scale.."\027[0m") end
			return false
		end
	else
		if toDebug then print("\027[31m".."Failed at Height:",height..scale.."\027[0m") end
		return false 
	end

	-- Check Hair Color: # followed by 6 hex numbers.
	local hair = passport["hcl"]
	if not string.match(hair,"^%#"..string.rep("[%dabcdefABCDEF]",6).."$") then
		if toDebug then print("\027[31m".."Failed at Hair:",hair.."\027[0m") end
		return false 
	end

	-- Check Eye Color: From table.
	local eye = passport["ecl"]
	if not table_find(eyeColors, eye) then
		if toDebug then print("\027[31m".."Failed at Eye:",eye.."\027[0m") end
		return false 
	end

	-- Check PassportID: 9 digit number.
	local id = passport["pid"]
	if not string.match(id, "^"..string.rep("%d",9).."$") then
		if toDebug then print("\027[31m".."Failed at PassportID:",id.."\027[0m") end
		return false
	end

	if toDebug then print("\027[32m".."All Passed.".."\027[0m") end
	-- All checks passed.
	return true
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

	local eyeColors = {
		"amb",
		"blu",
		"brn",
		"gry",
		"grn",
		"hzl",
		"oth"
	}

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

	for idx,passport in ipairs(passports) do
		-- Debugging
		local toDebug = false
		if toDebug then print("Checking IDX:",idx) end
		if isPassportValid(passport, requiredFields, eyeColors, toDebug) then
			answer = answer + 1
		end
	end
	print("For File:",file,"Answer is:",answer)
end
