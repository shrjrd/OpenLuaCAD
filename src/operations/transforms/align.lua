-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Number = LuauPolyfill.Number
local Object = LuauPolyfill.Object
local flatten = require("../../utils/flatten")
local padArrayToLength = require("../../utils/padArrayToLength")
local measureAggregateBoundingBox = require("../../measurements/measureAggregateBoundingBox")
local translate = require("./translate").translate
local function validateOptions(options)
	if
		not Boolean.toJSBoolean(Array.isArray(options.modes))
		or #options.modes > 3 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		error(Error.new("align(): modes must be an array of length <= 3"))
	end
	options.modes = padArrayToLength(options.modes, "none", 3)
	if
		Array
			.filter(options.modes, function(mode)
				return Array.includes({ "center", "max", "min", "none" }, mode)
			end) --[[ ROBLOX CHECK: check if 'options.modes' is an Array ]]
			.length ~= 3
	then
		error(Error.new('align(): all modes must be one of "center", "max" or "min"'))
	end
	if
		not Boolean.toJSBoolean(Array.isArray(options.relativeTo))
		or #options.relativeTo > 3 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		error(Error.new("align(): relativeTo must be an array of length <= 3"))
	end
	options.relativeTo = padArrayToLength(options.relativeTo, 0, 3)
	if
		Array
			.filter(options.relativeTo, function(alignVal)
				local ref = Number.isFinite(alignVal)
				return Boolean.toJSBoolean(ref) and ref or alignVal == nil --[[ ROBLOX CHECK: loose equality used upstream ]]
			end) --[[ ROBLOX CHECK: check if 'options.relativeTo' is an Array ]]
			.length ~= 3
	then
		error(Error.new("align(): all relativeTo values must be a number, or null."))
	end
	if typeof(options.grouped) ~= "boolean" then
		error(Error.new("align(): grouped must be a boolean value."))
	end
	return options
end
local function populateRelativeToFromBounds(relativeTo, modes, bounds)
	do
		local i = 0
		while
			i
			< 3 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			if
				relativeTo[i] == nil --[[ ROBLOX CHECK: loose equality used upstream ]]
			then
				if modes[i] == "center" then
					relativeTo[i] = (
						bounds[
							1 --[[ ROBLOX adaptation: added 1 to array index ]]
						][i] + bounds[
							2 --[[ ROBLOX adaptation: added 1 to array index ]]
						][i]
					) / 2
				elseif modes[i] == "max" then
					relativeTo[i] = bounds[
						2 --[[ ROBLOX adaptation: added 1 to array index ]]
					][i]
				elseif modes[i] == "min" then
					relativeTo[i] = bounds[
						1 --[[ ROBLOX adaptation: added 1 to array index ]]
					][i]
				end
			end
			i += 1
		end
	end
	return relativeTo
end
local function alignGeometries(geometry, modes, relativeTo)
	local bounds = measureAggregateBoundingBox(geometry)
	local translation = { 0, 0, 0 }
	do
		local i = 0
		while
			i
			< 3 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			if modes[i] == "center" then
				translation[i] = relativeTo[i]
					- (
							bounds[
								1 --[[ ROBLOX adaptation: added 1 to array index ]]
							][i]
							+ bounds[
								2 --[[ ROBLOX adaptation: added 1 to array index ]]
							][i]
						)
						/ 2
			elseif modes[i] == "max" then
				translation[i] = relativeTo[i]
					- bounds[
						2 --[[ ROBLOX adaptation: added 1 to array index ]]
					][i]
			elseif modes[i] == "min" then
				translation[i] = relativeTo[i]
					- bounds[
						1 --[[ ROBLOX adaptation: added 1 to array index ]]
					][i]
			end
			i += 1
		end
	end
	return translate(translation, geometry)
end
--[=[*
 * Align the boundaries of the given geometries using the given options.
 * @param {Object} options - options for aligning
 * @param {Array} [options.modes = ['center', 'center', 'min']] - the point on the geometries to align to for each axis. Valid options are "center", "max", "min", and "none".
 * @param {Array} [options.relativeTo = [0,0,0]] - The point one each axis on which to align the geometries upon.  If the value is null, then the corresponding value from the group's bounding box is used.
 * @param {Boolean} [options.grouped = false] - if true, transform all geometries by the same amount, maintaining the relative positions to each other.
 * @param {...Object} geometries - the geometries to align
 * @return {Object|Array} the aligned geometry, or a list of aligned geometries
 * @alias module:modeling/transforms.align
 *
 * @example
 * let alignedGeometries = align({modes: ['min', 'center', 'none'], relativeTo: [10, null, 10], grouped: true }, geometries)
 ]=]
local function align(
	options,
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local geometries = { ... }
	local defaults = { modes = { "center", "center", "min" }, relativeTo = { 0, 0, 0 }, grouped = false }
	options = Object.assign({}, defaults, options)
	options = validateOptions(options)
	local modes, relativeTo, grouped = options.modes, options.relativeTo, options.grouped
	geometries = flatten(geometries)
	if #geometries == 0 then
		error(Error.new("align(): No geometries were provided to act upon"))
	end
	if
		Boolean.toJSBoolean(Array
			.filter(relativeTo, function(val)
				return val == nil --[[ ROBLOX CHECK: loose equality used upstream ]]
			end) --[[ ROBLOX CHECK: check if 'relativeTo' is an Array ]]
			.length)
	then
		local bounds = measureAggregateBoundingBox(geometries)
		relativeTo = populateRelativeToFromBounds(relativeTo, modes, bounds)
	end
	if Boolean.toJSBoolean(grouped) then
		geometries = alignGeometries(geometries, modes, relativeTo)
	else
		geometries = Array.map(geometries, function(geometry)
			return alignGeometries(geometry, modes, relativeTo)
		end) --[[ ROBLOX CHECK: check if 'geometries' is an Array ]]
	end
	return if #geometries == 1
		then geometries[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		else geometries
end
return align
