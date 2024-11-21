-- ROBLOX NOTE: no upstream
local vec3 = require("../vec3")
local fromRotation = require("./fromRotation")
--[[*
 * Create a matrix that rotates the given source to the given target vector.
 *
 * Each vector must be a directional vector with a length greater than zero.
 * @see https://gist.github.com/kevinmoran/b45980723e53edeb8a5a43c49f134724
 * @param {mat4} out - receiving matrix
 * @param {vec3} source - source vector
 * @param {vec3} target - target vector
 * @returns {mat4} a new matrix
 * @alias module:modeling/maths/mat4.fromVectorRotation
 * @example
 * let matrix = fromVectorRotation(mat4.create(), [1, 2, 2], [-3, 3, 12])
 ]]
local function fromVectorRotation(out, source, target)
	local sourceNormal = vec3.normalize(vec3.create(), source)
	local targetNormal = vec3.normalize(vec3.create(), target)
	local axis = vec3.cross(vec3.create(), targetNormal, sourceNormal)
	local cosA = vec3.dot(targetNormal, sourceNormal)
	if cosA == -1.0 then
		return fromRotation(out, math.pi, vec3.orthogonal(axis, sourceNormal))
	end
	local k = 1 / (1 + cosA)
	out[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = axis[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
			* axis[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			* k
		+ cosA
	out[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = axis[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
			* axis[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			* k
		- axis[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	out[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = axis[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
			* axis[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			* k
		+ axis[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	out[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 0
	out[
		5 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = axis[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
			* axis[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			* k
		+ axis[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	out[
		6 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = axis[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
			* axis[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			* k
		+ cosA
	out[
		7 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = axis[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
			* axis[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			* k
		- axis[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	out[
		8 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 0
	out[
		9 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = axis[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
			* axis[
				3 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			* k
		- axis[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	out[
		10 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = axis[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
			* axis[
				3 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			* k
		+ axis[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	out[
		11 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = axis[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
			* axis[
				3 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			* k
		+ cosA
	out[
		12 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 0
	out[
		13 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 0
	out[
		14 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 0
	out[
		15 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 0
	out[
		16 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 1
	return out
end
return fromVectorRotation
