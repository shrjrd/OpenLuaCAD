-- ROBLOX NOTE: no upstream
local EPS = require("../../maths/constants").EPS
local measureBoundingBox = require("../../measurements/measureBoundingBox")
--[[
 * Determine if the given geometries overlap by comparing min and max bounds.
 * NOTE: This is used in union for performance gains.
 * @param {geom3} geometry1 - geometry for comparison
 * @param {geom3} geometry2 - geometry for comparison
 * @returns {boolean} true if the geometries overlap
 ]]
local function mayOverlap(geometry1, geometry2)
	-- FIXME accessing the data structure of the geometry should not be allowed
	if #geometry1.polygons == 0 or #geometry2.polygons == 0 then
		return false
	end
	local bounds1 = measureBoundingBox(geometry1)
	local min1 = bounds1[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local max1 = bounds1[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local bounds2 = measureBoundingBox(geometry2)
	local min2 = bounds2[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local max2 = bounds2[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	if
		min2[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			- max1[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
		> EPS --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		return false
	end
	if
		min1[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			- max2[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
		> EPS --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		return false
	end
	if
		min2[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			- max1[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
		> EPS --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		return false
	end
	if
		min1[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			- max2[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
		> EPS --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		return false
	end
	if
		min2[
				3 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			- max1[
				3 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
		> EPS --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		return false
	end
	if
		min1[
				3 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			- max2[
				3 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
		> EPS --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		return false
	end
	return true
end
return mayOverlap
