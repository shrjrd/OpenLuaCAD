-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Error = LuauPolyfill.Error
local vec3 = require("../../maths/vec3")
local mat4 = require("../../maths/mat4")
local poly3 = require("../poly3")
local create = require("./create")
--[[*
 * Construct a new 3D geometry from the given compact binary data.
 * @param {TypedArray} data - compact binary data
 * @returns {geom3} a new geometry
 * @alias module:modeling/geometries/geom3.fromCompactBinary
 ]]
local function fromCompactBinary(data)
	if
		data[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] ~= 1
	then
		error(Error.new("invalid compact binary data"))
	end
	local created = create()
	created.transforms = mat4.clone(Array.slice(data, 1, 17) --[[ ROBLOX CHECK: check if 'data' is an Array ]])
	local numberOfVertices = data[
		22 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local ci = 22
	local vi = #data - numberOfVertices * 3
	while
		vi
		< #data --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	do
		local verticesPerPolygon = data[ci]
		ci += 1
		local vertices = {}
		do
			local i = 0
			while
				i
				< verticesPerPolygon --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
			do
				table.insert(vertices, vec3.fromValues(data[vi], data[(vi + 1)], data[(vi + 2)])) --[[ ROBLOX CHECK: check if 'vertices' is an Array ]]
				vi += 3
				i += 1
			end
		end
		table.insert(created.polygons, poly3.create(vertices)) --[[ ROBLOX CHECK: check if 'created.polygons' is an Array ]]
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
