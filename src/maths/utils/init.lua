-- ROBLOX NOTE: no upstream
--[[*
 * Utility functions for maths.
 * @module modeling/maths/utils
 * @example
 * const { area, solve2Linear } = require('@jscad/maths').utils
 ]]
return {
	aboutEqualNormals = require("./aboutEqualNormals"),
	area = require("./area"),
	cos = require("./trigonometry").cos,
	interpolateBetween2DPointsForY = require("./interpolateBetween2DPointsForY"),
	intersect = require("./intersect"),
	sin = require("./trigonometry").sin,
	solve2Linear = require("./solve2Linear"),
}
