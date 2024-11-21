-- ROBLOX NOTE: no upstream
--[[*
 * Get the X coordinate of a point with a certain Y coordinate, interpolated between two points.
 * Interpolation is robust even if the points have the same Y coordinate
 * @param {vec2} point1
 * @param {vec2} point2
 * @param {Number} y
 * @return {Array} X and Y of interpolated point
 * @alias module:modeling/maths/utils.interpolateBetween2DPointsForY
 ]]
local function interpolateBetween2DPointsForY(point1, point2, y)
	local f1 = y - point1[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local f2 = point2[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] - point1[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	if
		f2 < 0 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		f1 = -f1
		f2 = -f2
	end
	local t
	if
		f1
		<= 0 --[[ ROBLOX CHECK: operator '<=' works only if either both arguments are strings or both are a number ]]
	then
		t = 0.0
	elseif
		f1
		>= f2 --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
	then
		t = 1.0
	elseif
		f2
		< 1e-10 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		-- FIXME Should this be EPS?
		t = 0.5
	else
		t = f1 / f2
	end
	local result = point1[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
		+ t
			* (
				point2[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				] - point1[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
			)
	return result
end
return interpolateBetween2DPointsForY
