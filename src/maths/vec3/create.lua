-- ROBLOX NOTE: no upstream
--[[*
 * Represents a three dimensional vector.
 * See fromValues().
 * @typedef {Array} vec3
 ]]
--[[*
 * Creates a new vector initialized to [0,0,0].
 *
 * @returns {vec3} a new vector
 * @alias module:modeling/maths/vec3.create
 ]]
local function create()
	return { 0, 0, 0 }
end
return create
