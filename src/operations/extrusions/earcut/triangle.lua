-- ROBLOX NOTE: no upstream
--[[
 * check if a point lies within a convex triangle
 ]]
local function pointInTriangle(ax, ay, bx, by, cx, cy, px, py)
	return (cx - px) * (ay - py) - (ax - px) * (cy - py) >= 0 --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
		and (ax - px) * (by - py) - (bx - px) * (ay - py) >= 0 --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
		and (bx - px) * (cy - py) - (cx - px) * (by - py) >= 0 --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
end
--[[
 * signed area of a triangle
 ]]
local function area(p, q, r)
	return (q.y - p.y) * (r.x - q.x) - (q.x - p.x) * (r.y - q.y)
end
return { area = area, pointInTriangle = pointInTriangle }
