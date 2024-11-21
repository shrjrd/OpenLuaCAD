-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local mat4 = require("../../maths/mat4")
local vec2 = require("../../maths/vec2")
local create = require("./create")
--[[*
 * Create a new path from the given compact binary data.
 * @param {TypedArray} data - compact binary data
 * @returns {path2} a new path
 * @alias module:modeling/geometries/path2.fromCompactBinary
 ]]
local function fromCompactBinary(data)
	if
		data[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] ~= 2
	then
		error(Error.new("invalid compact binary data"))
	end
	local created = create()
	created.transforms = mat4.clone(Array.slice(data, 1, 17) --[[ ROBLOX CHECK: check if 'data' is an Array ]])
	created.isClosed = not not Boolean.toJSBoolean(data[
		18 --[[ ROBLOX adaptation: added 1 to array index ]]
	])
	do
		local i = 22
		while
			i
			< #data --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			local point = vec2.fromValues(data[i], data[(i + 1)])
			table.insert(created.points, point) --[[ ROBLOX CHECK: check if 'created.points' is an Array ]]
			i += 2
		end
	end -- transfer known properties, i.e. color
	if
		data[
			19 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		>= 0 --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
	then
		created.color = {
			data[
				19 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			data[
				20 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			data[
				21 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			data[
				22 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
		}
	end -- TODO: how about custom properties or fields ?
	return created
end
return fromCompactBinary
