-- Advent of Code: Day 22,Part 1
-- DevTenga
-- 22/12/2021

-- https://adventofcode.com/2021/day/22

function table_reverse(t, preserveOriginal)
	local len = #t + 1
	local _t = {}

	for i,v in next,t do
		_t[len - i] = v
	end

	t = preserveOriginal and t or _t
	return _t
end


local function parse_zone(zoneObj, usedZones)
	local zones = {zoneObj.zone}

	-- Remove used zone parts from current zones.
	for _,usedZone in next, usedZones do
		for _, currentZone in next, zones do
			if 
				usedZone.x[1] <= currentZone.x[2]
				and usedZone.x[2] >= currentZone.x[1]
				and usedZone.y[1] <= currentZone.y[2]
				and usedZone.y[2] >= currentZone.y[1]
				and usedZone.z[1] <= currentZone.z[2]
				and usedZone.z[2] >= currentZone.z[1]
			then


			end
		end
	end

end




local regex = "(%w+)"
.."%s+x%=(%-*%d+)%.%.(%-*%d+)%,"
.."%s+y%=(%-*%d+)%.%.(%-*%d+)%,"
.."%s+z%=(%-*%d+)%.%.(%-*%d+)"

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

		-- Range limiting for Part 1.
		if x1 >= -50 and y1 >= -50 and z1 >= -50 
			and x2 <= 50 and y2 <= 50 and z2 <= 50 
		then
			zones[#zones + 1] = {
				command = command; 
				
				zone = {
					x = {x1,x2}, 
					y = {y1,y2}, 
					z = {z1,z2}
				}
			}

		end
	end

	table_reverse(zones,false)
	local answer = 0

	for _,zone in ipairs(zones) do
		answer = answer + parse_zone(zone, usedZones)
	end

	print("For File:",file,"Answer is:",answer)
end
