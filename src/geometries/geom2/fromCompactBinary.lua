-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local Error = LuauPolyfill.Error
local mat4 = require("../../maths/mat4")
local vec2 = require("../../maths/vec2")
local create = require("./create")
--[[*
 * Create a new 2D geometry from the given compact binary data.
 * @param {Array} data - compact binary data
 * @returns {geom2} a new geometry
 * @alias module:modeling/geometries/geom2.fromCompactBinary
 ]]
local function fromCompactBinary(data)
	if
		data[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] ~= 0
	then
		error(Error.new("invalid compact binary data"))
	end
	local created = create()
	created.transforms = mat4.clone(Array.slice(data, 1, 17) --[[ ROBLOX CHECK: check if 'data' is an Array ]])
	do
		local i = 21
		while
			i
			< #data --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			local point0 = vec2.fromValues(data[(i + 0)], data[(i + 1)])
			local point1 = vec2.fromValues(data[(i + 2)], data[(i + 3)])
			table.insert(created.sides, { point0, point1 }) --[[ ROBLOX CHECK: check if 'created.sides' is an Array ]]
			i += 4
		end
	end -- transfer known properties, i.e. color
	if
		data[
			18 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		>= 0 --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
	then
		created.color = {
			data[
				18 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			data[
				19 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			data[
				20 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			data[
				21 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
		}
	end -- TODO: how about custom properties or fields ?
	return created
end
return fromCompactBinary
