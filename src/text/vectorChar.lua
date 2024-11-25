-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local vectorParams = require("./vectorParams")
--[=[*
 * Represents a character as a list of segments
 * @typedef {Object} VectorCharObject
 * @property {Float} width - character width
 * @property {Float} height - character height (uppercase)
 * @property {Array} segments - character segments [[[x, y], ...], ...]
 ]=]
--[[* Construct a {@link VectorCharObject} from a ascii character whose code is between 31 and 127,
* if the character is not supported it is replaced by a question mark.
* @param {Object|String} [options] - options for construction or ascii character
* @param {Float} [options.xOffset=0] - x offset
* @param {Float} [options.yOffset=0] - y offset
* @param {Float} [options.height=21] - font size (uppercase height)
* @param {Float} [options.extrudeOffset=0] - width of the extrusion that will be applied (manually) after the creation of the character
* @param {String} [options.input='?'] - ascii character (ignored/overwrited if provided as seconds parameter)
* @param {String} [char='?'] - ascii character
* @returns {VectorCharObject}
* @alias module:modeling/text.vectorChar
*
* @example
* let vectorCharObject = vectorChar()
* or
* let vectorCharObject = vectorChar('A')
* or
* let vectorCharObject = vectorChar({ xOffset: 57 }, 'C')
* or
* let vectorCharObject = vectorChar({ xOffset: 78, input: '!' })
]]
local function vectorChar(options, char)
	local xOffset, yOffset, input, font, height, extrudeOffset
	do
		local ref = vectorParams(options, char)
		xOffset, yOffset, input, font, height, extrudeOffset =
			ref.xOffset, ref.yOffset, ref.input, ref.font, ref.height, ref.extrudeOffset
	end
	local code = input:charCodeAt(0)
	if not Boolean.toJSBoolean(code) or not Boolean.toJSBoolean(font[code]) then
		code = 63 -- 63 => ?
	end
	local glyph = Array.concat({}, font[code])
	local ratio = (height - extrudeOffset) / font.height
	local extrudeYOffset = extrudeOffset / 2
	local width = table.remove(glyph, 1) --[[ ROBLOX CHECK: check if 'glyph' is an Array ]]
		* ratio
	local segments = {}
	local polyline = {}
	do
		local i, il = 0, #glyph
		while
			i
			< il --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			local gx = ratio * glyph[i] + xOffset
			local gy = ratio * glyph[(i + 1)] + yOffset + extrudeYOffset
			if glyph[i] ~= nil then
				table.insert(polyline, { gx, gy }) --[[ ROBLOX CHECK: check if 'polyline' is an Array ]]
				i += 2
				continue
			end
			table.insert(segments, polyline) --[[ ROBLOX CHECK: check if 'segments' is an Array ]]
			polyline = {}
			i -= 1
			i += 2
		end
	end
	if Boolean.toJSBoolean(#polyline) then
		table.insert(segments, polyline) --[[ ROBLOX CHECK: check if 'segments' is an Array ]]
	end
	return { width = width, height = height, segments = segments }
end
return vectorChar
