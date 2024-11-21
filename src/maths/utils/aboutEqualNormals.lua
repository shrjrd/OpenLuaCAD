-- ROBLOX NOTE: no upstream
local NEPS = require("../constants").NEPS
--[[*
 * Compare two normals (unit vectors) for near equality.
 * @param {vec3} a - normal a
 * @param {vec3} b - normal b
 * @returns {Boolean} true if a and b are nearly equal
 * @alias module:modeling/maths/utils.aboutEqualNormals
 ]]
local function aboutEqualNormals(a, b)
	return math.abs(a[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] - b[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]) <= NEPS --[[ ROBLOX CHECK: operator '<=' works only if either both arguments are strings or both are a number ]] and math.abs(
		a[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		] - b[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
	) <= NEPS --[[ ROBLOX CHECK: operator '<=' works only if either both arguments are strings or both are a number ]] and math.abs(
		a[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		] - b[
				3 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
	) <= NEPS --[[ ROBLOX CHECK: operator '<=' works only if either both arguments are strings or both are a number ]]
end
return aboutEqualNormals
