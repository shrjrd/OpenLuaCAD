-- ROBLOX NOTE: no upstream
--[[*
 * Represents a four dimensional vector.
 * See fromValues().
 * @typedef {Array} vec4
 ]]
--[[*
 * Creates a new vector initialized to [0,0,0,0].
 *
 * @returns {vec4} a new vector
 * @alias module:modeling/maths/vec4.create
 ]]
local function create()
	return { 0, 0, 0, 0 }
end
return create
