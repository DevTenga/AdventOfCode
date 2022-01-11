-- Advent of Code: Day 22,Part 2
-- DevTenga
-- 22/12/2021

-- https://adventofcode.com/2021/day/22

-- ========================== Table Utilities ========================== --
function table_reverse(t)
	local len = #t + 1
	local _t = {}

	for i,v in next,t do
		_t[len - i] = v
	end

	return _t
end

function table_copy(t)
	local _t = {}
	for k,v in next,t do _t[k] = v end 
	return _t
end

function table_deepPrint(t,tabCount,_isRecursive)
	tabCount = tabCount or 0
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
	if not _isRecursive then print("\n\n======================\n\n") end
end

-- ========================== Core Functions =========================== --
local function get_other_axes(axis)
	if axis == 'x' then
		return 'y', 'z'
	elseif axis == 'y' then
		return 'x', 'z'
	elseif axis == 'z' then
		return 'x','y'
	end
end

local function is_in_zone(parentZone,childZone)
	for _, axis in ipairs {'x','y','z'} do
		if childZone[axis][2] < parentZone[axis][1] then
			return false
		end
		if childZone[axis][1] > parentZone[axis][2] then
			return false
		end
	end
	return true
end

local function get_right_slice(parentZone,childZone,axis)
	local axis1, axis2 = get_other_axes(axis)

	local slice = {}
	slice[axis] = {childZone[axis][2] + 1, parentZone[axis][2]}
	slice[axis1] = table_copy(parentZone[axis1])
	slice[axis2] = table_copy(parentZone[axis2])
	return slice
end

local function get_left_slice(parentZone, childZone, axis)
	local axis1, axis2 = get_other_axes(axis)

	local slice = {}
	slice[axis] = {parentZone[axis][1], childZone[axis][1] - 1}
	slice[axis1] = table_copy(parentZone[axis1])
	slice[axis2] = table_copy(parentZone[axis2]) 
	return slice
end

local function get_middle_slice(parentZone, childZone, axis)
	local axis1, axis2 = get_other_axes(axis)
	local main1 = math.max(parentZone[axis][1], childZone[axis][1])
	local main2 = math.min(parentZone[axis][2], childZone[axis][2])

	local slice = {}
	slice[axis] = {main1, main2}
	slice[axis1] = table_copy(parentZone[axis1])
	slice[axis2] = table_copy(parentZone[axis2]) 
	return slice
end

local function view_zones(zones)
	for _, zone in ipairs(zones) do
		for x = zone.x[1], zone.x[2] do
			for y = zone.y[1], zone.y[2] do
				for z = zone.z[1], zone.z[2] do
					print(string.format("%d,%d,%d",x,y,z))
				end
			end
		end
	end
end

local function get_volume(zones)
	local volume = 0
	for _, zone in ipairs(zones) do
		local x = zone.x[2] - zone.x[1] + 1
		local y = zone.y[2] - zone.y[1] + 1
		local z = zone.z[2] - zone.z[1] + 1

		volume = volume + math.abs(x * y * z)
	end
	return volume
end


------------- Main Function -------------
local function parse_zone(zoneObj, usedZones)
	local zones = {zoneObj.zone}

	-- Note: Remove used zone parts from current zones.
	for _,usedZone in next, usedZones do
		local _zones = {}
		local idx = 1
		
		for _, currentZone in next, zones do
			if is_in_zone(currentZone, usedZone) then
				
				for _, axis in ipairs {'x','y','z'} do
					if usedZone[axis][1] <= currentZone[axis][1] and usedZone[axis][2] >= currentZone[axis][2] then
						-- pass
					elseif usedZone[axis][1] <= currentZone[axis][1] then
						_zones[idx] = get_right_slice(currentZone, usedZone, axis)
						currentZone = get_middle_slice(currentZone, usedZone, axis)
						idx = idx + 1
					elseif usedZone[axis][2] >= currentZone[axis][2] then
						_zones[idx] = get_left_slice(currentZone, usedZone, axis)
						currentZone = get_middle_slice(currentZone, usedZone, axis)
						idx = idx + 1
					elseif 
						usedZone[axis][1] > currentZone[axis][1] 
						and usedZone[axis][2] < currentZone[axis][2] 
					then
						_zones[idx] = get_right_slice(currentZone, usedZone, axis)
						_zones[idx + 1] = get_left_slice(currentZone, usedZone, axis)
						currentZone = get_middle_slice(currentZone, usedZone, axis)
						idx = idx + 2
					end
				end
			else
				_zones[idx] = currentZone
				idx = idx + 1
			end
		end
		zones = _zones
	end
	table.move(zones,1,#zones,#usedZones + 1,usedZones)
	return zoneObj.command == "on" and get_volume(zones) or 0
end
-----------------------------------------

-- ============================ Code Flow ============================== --
local regex = "(%w+)"
.."%s+x%=(%-*%d+)%.%.(%-*%d+)%,"
.."%s*y%=(%-*%d+)%.%.(%-*%d+)%,"
.."%s*z%=(%-*%d+)%.%.(%-*%d+)"

for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	local zones = {}
	local usedZones = {}
	
	for command,x1,x2,y1,y2,z1,z2 in string.gmatch(contents,regex) do
		x1 = tonumber(x1)
		x2 = tonumber(x2)
		y1 = tonumber(y1)
		y2 = tonumber(y2)
		z1 = tonumber(z1)
		z2 = tonumber(z2)

		-- Removed range limiting for Part 2.
		zones[#zones + 1] = {
			command = command; 
			
			zone = {
				x = {x1,x2}, 
				y = {y1,y2}, 
				z = {z1,z2}
			}
		}
	end

	zones = table_reverse(zones)
	local answer = 0

	for idx,zone in ipairs(zones) do
		answer = answer + parse_zone(zone, usedZones)
		answer = answer < 0 and 0 or answer
	end

	print("For File:",file,"Answer is:",answer)
end
