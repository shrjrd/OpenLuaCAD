-- ROBLOX NOTE: no upstream
local function solve2Linear(a, b, c, d, u, v)
	local det = a * d - b * c
	local invdet = 1.0 / det
	local x = u * d - b * v
	local y = -u * c + a * v
	x *= invdet
	y *= invdet
	return { x, y }
end
return solve2Linear
