-- ROBLOX NOTE: no upstream
--[[*
 * Measure the area under the given polygon.
 *
 * @param {poly2} polygon - the polygon to measure
 * @return {Number} the area of the polygon
 * @alias module:modeling/geometries/poly2.measureArea
 ]]
local area = require("../../maths/utils/area")
local function measureArea(polygon)
	return area(polygon.vertices)
end
return measureArea
