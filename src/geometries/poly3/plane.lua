-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local mplane = require("../../maths/plane/")
local function plane(polygon)
	if not Boolean.toJSBoolean(polygon.plane) then
		polygon.plane = mplane.fromPoints(mplane.create(), table.unpack(Array.spread(polygon.vertices)))
	end
	return polygon.plane
end
return plane
