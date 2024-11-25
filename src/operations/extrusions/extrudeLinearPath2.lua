-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local geom2 = require("../../geometries/geom2")
local path2 = require("../../geometries/path2")
local extrudeLinearGeom2 = require("./extrudeLinearGeom2")
--[[
 * Extrude the given geometry using the given options.
 *
 * @param {Object} [options] - options for extrude
 * @param {Array} [options.offset] - the direction of the extrusion as a 3D vector
 * @param {Number} [options.twistAngle] - the final rotation (RADIANS) about the origin
 * @param {Integer} [options.twistSteps] - the number of steps created to produce the twist (if any)
 * @param {path2} geometry - the geometry to extrude
 * @returns {geom3} the extruded 3D geometry
]]
local function extrudePath2(options, geometry)
	if not Boolean.toJSBoolean(geometry.isClosed) then
		error(Error.new("extruded path must be closed"))
	end -- Convert path2 to geom2
	local points = path2.toPoints(geometry)
	local geometry2 = geom2.fromPoints(points)
	return extrudeLinearGeom2(options, geometry2)
end
return extrudePath2
