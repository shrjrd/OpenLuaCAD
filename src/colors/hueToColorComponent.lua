-- ROBLOX NOTE: no upstream
--[[*
 * Convert hue values to a color component (ie one of r, g, b)
 * @param  {Number} p
 * @param  {Number} q
 * @param  {Number} t
 * @return {Number} color component
 * @alias module:modeling/colors.hueToColorComponent
 ]]
local function hueToColorComponent(p, q, t)
	if
		t < 0 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		t += 1
	end
	if
		t > 1 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		t -= 1
	end
	if
		t
		< 1 / 6 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		return p + (q - p) * 6 * t
	end
	if
		t
		< 1 / 2 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		return q
	end
	if
		t
		< 2 / 3 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		return p + (q - p) * (2 / 3 - t) * 6
	end
	return p
end
return hueToColorComponent
