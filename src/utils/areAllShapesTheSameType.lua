-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Boolean = LuauPolyfill.Boolean
-- list of supported geometries
local geom2 = require("../geometries/geom2")
local geom3 = require("../geometries/geom3")
local path2 = require("../geometries/path2")
--[[*
 * @param {Array} shapes - list of shapes to compare
 * @returns {Boolean} true if the given shapes are of the same type
 * @alias module:modeling/utils.areAllShapesTheSameType
 ]]
local function areAllShapesTheSameType(shapes)
	local previousType
	for _, shape in shapes do
		local currentType = 0
		if Boolean.toJSBoolean(geom2.isA(shape)) then
			currentType = 1
		end
		if Boolean.toJSBoolean(geom3.isA(shape)) then
			currentType = 2
		end
		if Boolean.toJSBoolean(path2.isA(shape)) then
			currentType = 3
		end
		if
			Boolean.toJSBoolean(if Boolean.toJSBoolean(previousType) then currentType ~= previousType else previousType)
		then
			return false
		end
		previousType = currentType
	end
	return true
end
return areAllShapesTheSameType
