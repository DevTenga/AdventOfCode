-- Advent of Code: Day 17,Part 2
-- DevTenga
-- 17/12/2021

-- https://adventofcode.com/2021/day/17

local function fact_upto(C, P)
	print(C, P)
	local prod = 1
	for i = C, P, -1 do prod = prod * i end
	return prod
end



for _,file in ipairs(arg) do
	local contents = io.open(file):read("*all")

	-- We will brute-force the answer.

	local x1,x2,y1,y2 = string.match(contents,"target area: x=(%-?%d+)%.%.(%-?%d+)%, y%=(%-?%d+)%.%.(%-?%d+)")
	x1 = tonumber(x1)
	x2 = tonumber(x2)
	y1 = tonumber(y1)
	y2 = tonumber(y2)

	local pX, pY = {}, {}

	local validVel = {}
	local validCount = 0

	local xMax, xMin = math.max(x1, x2), math.min(x1, x2)
	local yMax, yMin = math.max(y1, y2), math.min(y1, y2)
	local yTop = math.abs(yMin)

	print(xMax,xMin)

	local function check_vel(vX,vY,toInsert)
		local _vX,_vY = vX, vY
		local pX, pY = 0,0
		
		while pX <= xMax and pY >= yMin do
			pX = pX + vX
			pY = pY + vY
			vX = (vX > 0 and vX - 1) or (vX < 0 and vX + 1) or vX
			vY = vY - 1

			if pX <= xMax and pX >= xMin and pY <= yMax and pY >= yMin then
				validCount = validCount + 1
				if toInsert then validVel[validCount] = string.format("(%s,%s)",_vX,_vY) end
				break
			end
		end
	end

	for x = 0, xMax do
		for y = yTop, yMin, -1 do
			check_vel(x,y,true)
		end
	end

	local answer = validCount 
	print("For File:",file,"Answer is:",answer)
end
