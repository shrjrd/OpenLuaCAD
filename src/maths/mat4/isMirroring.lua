-- ROBLOX NOTE: no upstream
--[[*
 * Determine whether the given matrix is a mirroring transformation.
 *
 * @param {mat4} matrix - matrix of reference
 * @returns {Boolean} true if matrix is a mirroring transformation
 * @alias module:modeling/maths/mat4.isMirroring
 ]]
local function isMirroring(matrix)
	-- const xVector = [matrix[0], matrix[4], matrix[8]]
	-- const yVector = [matrix[1], matrix[5], matrix[9]]
	-- const zVector = [matrix[2], matrix[6], matrix[10]]
	-- for a true orthogonal, non-mirrored base, xVector.cross(yVector) == zVector
	-- If they have an opposite direction then we are mirroring
	-- calcuate xVector.cross(yVector)
	local x = matrix[
		5 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
			* matrix[
				10 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
		- matrix[
				9 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			* matrix[
				6 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
	local y = matrix[
		9 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
			* matrix[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
		- matrix[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			* matrix[
				10 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
	local z = matrix[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
			* matrix[
				6 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
		- matrix[
				5 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			* matrix[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			] -- calcualte dot(cross, zVector)
	local d = x * matrix[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		+ y * matrix[
			7 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		+ z * matrix[
			11 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	return d < 0 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
end
return isMirroring
