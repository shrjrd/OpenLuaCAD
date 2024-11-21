-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local vectorChar = require("./vectorChar")
local vectorParams = require("./vectorParams") -- translate text line
local function translateLine(options, line)
	local x, y
	do
		local ref = Object.assign({ x = 0, y = 0 }, Boolean.toJSBoolean(options) and options or {})
		x, y = ref.x, ref.y
	end
	local segments = line.segments
	local segment = nil
	local point = nil
	do
		local i, il = 0, #segments
		while
			i
			< il --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			segment = segments[i]
			do
				local j, jl = 0, #segment
				while
					j
					< jl --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
				do
					point = segment[j]
					segment[j] = {
						point[
							1 --[[ ROBLOX adaptation: added 1 to array index ]]
						] + x,
						point[
							2 --[[ ROBLOX adaptation: added 1 to array index ]]
						] + y,
					}
					j += 1
				end
			end
			i += 1
		end
	end
	return line
end
--[=[*
 * Construct an array of character segments from a ascii string whose characters code is between 31 and 127,
 * if one character is not supported it is replaced by a question mark.
 * @param {Object|String} [options] - options for construction or ascii string
 * @param {Float} [options.xOffset=0] - x offset
 * @param {Float} [options.yOffset=0] - y offset
 * @param {Float} [options.height=21] - font size (uppercase height)
 * @param {Float} [options.lineSpacing=1.4] - line spacing expressed as a percentage of font size
 * @param {Float} [options.letterSpacing=1] - extra letter spacing expressed as a percentage of font size
 * @param {String} [options.align='left'] - multi-line text alignment: left, center, right
 * @param {Float} [options.extrudeOffset=0] - width of the extrusion that will be applied (manually) after the creation of the character
 * @param {String} [options.input='?'] - ascii string (ignored/overwrited if provided as seconds parameter)
 * @param {String} [text='?'] - ascii string
 * @returns {Array} characters segments [[[x, y], ...], ...]
 * @alias module:modeling/text.vectorText
 *
 * @example
 * let textSegments = vectorText()
 * or
 * let textSegments = vectorText('OpenJSCAD')
 * or
 * let textSegments = vectorText({ yOffset: -50 }, 'OpenJSCAD')
 * or
 * let textSegments = vectorText({ yOffset: -80, input: 'OpenJSCAD' })
 ]=]
local function vectorText(options, text)
	local xOffset, yOffset, input, font, height, align, extrudeOffset, lineSpacing, letterSpacing
	do
		local ref = vectorParams(options, text)
		xOffset, yOffset, input, font, height, align, extrudeOffset, lineSpacing, letterSpacing =
			ref.xOffset,
			ref.yOffset,
			ref.input,
			ref.font,
			ref.height,
			ref.align,
			ref.extrudeOffset,
			ref.lineSpacing,
			ref.letterSpacing
	end
	local x, y = table.unpack({ xOffset, yOffset }, 1, 2)
	local i, il, char, vect, width, diff
	local line = { width = 0, segments = {} }
	local lines = {}
	local output = {}
	local maxWidth = 0
	local lineStart = x
	local function pushLine()
		table.insert(lines, line) --[[ ROBLOX CHECK: check if 'lines' is an Array ]]
		maxWidth = math.max(maxWidth, line.width)
		line = { width = 0, segments = {} }
	end
	i = 0
	il = #input
	while
		i < il --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	do
		char = input[i]
		vect = vectorChar({
			xOffset = x,
			yOffset = y,
			font = font,
			height = height,
			extrudeOffset = extrudeOffset,
		}, char)
		if char == "\n" then
			x = lineStart
			y -= vect.height * lineSpacing
			pushLine()
			i += 1
			continue
		end
		width = vect.width * letterSpacing
		line.width += width
		x += width
		if char ~= " " then
			line.segments = Array.concat(line.segments, vect.segments) --[[ ROBLOX CHECK: check if 'line.segments' is an Array ]]
		end
		i += 1
	end
	if Boolean.toJSBoolean(#line.segments) then
		pushLine()
	end
	i = 0
	il = #lines
	while
		i < il --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	do
		line = lines[i]
		if
			maxWidth
			> line.width --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		then
			diff = maxWidth - line.width
			if align == "right" then
				line = translateLine({ x = diff }, line)
			elseif align == "center" then
				line = translateLine({ x = diff / 2 }, line)
			end
		end
		output = Array.concat(output, line.segments) --[[ ROBLOX CHECK: check if 'output' is an Array ]]
		i += 1
	end
	return output
end
return vectorText
