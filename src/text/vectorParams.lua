-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local defaultFont = require("./fonts/single-line/hershey/simplex")
local defaultsVectorParams = {
	xOffset = 0,
	yOffset = 0,
	input = "?",
	align = "left",
	font = defaultFont,
	height = 14,
	-- == old vector_xxx simplex font height
	lineSpacing = 2.142857142857143,
	-- == 30/14 == old vector_xxx ratio
	letterSpacing = 1,
	extrudeOffset = 0,
} -- vectorsXXX parameters handler
local function vectorParams(options, input)
	if not Boolean.toJSBoolean(input) and typeof(options) == "string" then
		options = { input = options }
	end
	options = Boolean.toJSBoolean(options) and options or {}
	local params = Object.assign({}, defaultsVectorParams, options)
	params.input = Boolean.toJSBoolean(input) and input or params.input
	return params
end
return vectorParams
