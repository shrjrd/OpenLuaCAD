-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object
local geom3 = require("../geometries/geom3")
local poly3 = require("../geometries/poly3")
local isNumberArray = require("./commonChecks").isNumberArray
--[[*
 * Construct a polyhedron in three dimensional space from the given set of 3D points and faces.
 * The faces can define outward or inward facing polygons (orientation).
 * However, each face must define a counter clockwise rotation of points which follows the right hand rule.
 * @param {Object} options - options for construction
 * @param {Array} options.points - list of points in 3D space
 * @param {Array} options.faces - list of faces, where each face is a set of indexes into the points
 * @param {Array} [options.colors=undefined] - list of RGBA colors to apply to each face
 * @param {String} [options.orientation='outward'] - orientation of faces
 * @returns {geom3} new 3D geometry
 * @alias module:modeling/primitives.polyhedron
 *
 * @example
 * let mypoints = [ [10, 10, 0], [10, -10, 0], [-10, -10, 0], [-10, 10, 0], [0, 0, 10] ]
 * let myfaces = [ [0, 1, 4], [1, 2, 4], [2, 3, 4], [3, 0, 4], [1, 0, 3], [2, 1, 3] ]
 * let myshape = polyhedron({points: mypoint, faces: myfaces, orientation: 'inward'})
 ]]
local function polyhedron(options)
	local defaults = { points = {}, faces = {}, colors = nil, orientation = "outward" }
	local points, faces, colors, orientation
	do
		local ref = Object.assign({}, defaults, options)
		points, faces, colors, orientation = ref.points, ref.faces, ref.colors, ref.orientation
	end
	if
		not Boolean.toJSBoolean((function()
			local ref = Array.isArray(points)
			return if Boolean.toJSBoolean(ref) then Array.isArray(faces) else ref
		end)())
	then
		error(Error.new("points and faces must be arrays"))
	end
	if
		#points
		< 3 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		error(Error.new("three or more points are required"))
	end
	if
		#faces
		< 1 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		error(Error.new("one or more faces are required"))
	end
	if Boolean.toJSBoolean(colors) then
		if not Boolean.toJSBoolean(Array.isArray(colors)) then
			error(Error.new("colors must be an array"))
		end
		if #colors ~= #faces then
			error(Error.new("faces and colors must have the same length"))
		end
	end
	Array.forEach(points, function(point, i)
		if not Boolean.toJSBoolean(isNumberArray(point, 3)) then
			error(Error.new(("point %s must be an array of X, Y, Z values"):format(tostring(i))))
		end
	end) --[[ ROBLOX CHECK: check if 'points' is an Array ]]
	Array.forEach(faces, function(face, i)
		if
			#face
			< 3 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		then
			error(Error.new(("face %s must contain 3 or more indexes"):format(tostring(i))))
		end
		if not Boolean.toJSBoolean(isNumberArray(face, #face)) then
			error(Error.new(("face %s must be an array of numbers"):format(tostring(i))))
		end
	end) --[[ ROBLOX CHECK: check if 'faces' is an Array ]] -- invert the faces if orientation is inwards, as all internals expect outwarding facing polygons
	if orientation ~= "outward" then
		Array.forEach(faces, function(face)
			return Array.reverse(face) --[[ ROBLOX CHECK: check if 'face' is an Array ]]
		end) --[[ ROBLOX CHECK: check if 'faces' is an Array ]]
	end
	local polygons = Array.map(faces, function(face, findex)
		local polygon = poly3.create(Array.map(face, function(pindex)
			return points[pindex]
		end) --[[ ROBLOX CHECK: check if 'face' is an Array ]])
		if Boolean.toJSBoolean(if Boolean.toJSBoolean(colors) then colors[findex] else colors) then
			polygon.color = colors[findex]
		end
		return polygon
	end) --[[ ROBLOX CHECK: check if 'faces' is an Array ]]
	return geom3.create(polygons)
end
return polyhedron
