-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object
local geom2 = require("../geometries/geom2")
--[=[*
 * Construct a polygon in two dimensional space from a list of points, or a list of points and paths.
 *
 * NOTE: The ordering of points is important, and must define a counter clockwise rotation of points.
 *
 * @param {Object} options - options for construction
 * @param {Array} options.points - points of the polygon : either flat or nested array of 2D points
 * @param {Array} [options.paths] - paths of the polygon : either flat or nested array of point indexes
 * @param {String} [options.orientation='counterclockwise'] - orientation of points
 * @returns {geom2} new 2D geometry
 * @alias module:modeling/primitives.polygon
 *
 * @example
 * let roof = [[10,11], [0,11], [5,20]]
 * let wall = [[0,0], [10,0], [10,10], [0,10]]
 *
 * let poly = polygon({ points: roof })
 * or
 * let poly = polygon({ points: [roof, wall] })
 * or
 * let poly = polygon({ points: roof, paths: [0, 1, 2] })
 * or
 * let poly = polygon({ points: [roof, wall], paths: [[0, 1, 2], [3, 4, 5, 6]] })
 ]=]
local function polygon(options)
	local defaults = { points = {}, paths = {}, orientation = "counterclockwise" }
	local points, paths, orientation
	do
		local ref = Object.assign({}, defaults, options)
		points, paths, orientation = ref.points, ref.paths, ref.orientation
	end
	if
		not Boolean.toJSBoolean((function()
			local ref = Array.isArray(points)
			return if Boolean.toJSBoolean(ref) then Array.isArray(paths) else ref
		end)())
	then
		error(Error.new("points and paths must be arrays"))
	end
	local listofpolys = points
	if
		Boolean.toJSBoolean(Array.isArray(points[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]))
	then
		if
			not Boolean.toJSBoolean(Array.isArray(points[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			][
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]))
		then
			-- points is an array of something... convert to list
			listofpolys = { points }
		end
	end
	Array.forEach(listofpolys, function(list, i)
		if not Boolean.toJSBoolean(Array.isArray(list)) then
			error(Error.new("list of points " .. tostring(i) .. " must be an array"))
		end
		if
			#list
			< 3 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		then
			error(Error.new("list of points " .. tostring(i) .. " must contain three or more points"))
		end
		Array.forEach(list, function(point, j)
			if not Boolean.toJSBoolean(Array.isArray(point)) then
				error(Error.new("list of points " .. tostring(i) .. ", point " .. tostring(j) .. " must be an array"))
			end
			if
				#point
				< 2 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
			then
				error(
					Error.new(
						"list of points "
							.. tostring(i)
							.. ", point "
							.. tostring(j)
							.. " must contain by X and Y values"
					)
				)
			end
		end) --[[ ROBLOX CHECK: check if 'list' is an Array ]]
	end) --[[ ROBLOX CHECK: check if 'listofpolys' is an Array ]]
	local listofpaths = paths
	if #paths == 0 then
		-- create a list of paths based on the points
		local count = 0
		listofpaths = Array.map(listofpolys, function(list)
			return Array.map(list, function(point)
				local ref = count
				count += 1
				return ref
			end) --[[ ROBLOX CHECK: check if 'list' is an Array ]]
		end) --[[ ROBLOX CHECK: check if 'listofpolys' is an Array ]]
	end -- flatten the listofpoints for indexed access
	local allpoints = {}
	Array.forEach(listofpolys, function(list)
		return Array.forEach(list, function(point)
			return table.insert(allpoints, point) --[[ ROBLOX CHECK: check if 'allpoints' is an Array ]]
		end) --[[ ROBLOX CHECK: check if 'list' is an Array ]]
	end) --[[ ROBLOX CHECK: check if 'listofpolys' is an Array ]] -- convert the list of paths into a list of sides, and accumulate
	local sides = {}
	Array.forEach(listofpaths, function(path)
		local setofpoints = path.map(function(index)
			return allpoints[index]
		end)
		local geometry = geom2.fromPoints(setofpoints)
		sides = Array.concat(sides, geom2.toSides(geometry)) --[[ ROBLOX CHECK: check if 'sides' is an Array ]]
	end) --[[ ROBLOX CHECK: check if 'listofpaths' is an Array ]] -- convert the list of sides into a geometry
	local geometry = geom2.create(sides)
	if
		orientation == "clockwise" --[[ ROBLOX CHECK: loose equality used upstream ]]
	then
		geometry = Array.reverse(geom2, geometry) --[[ ROBLOX CHECK: check if 'geom2' is an Array ]]
	end
	return geometry
end
return polygon
