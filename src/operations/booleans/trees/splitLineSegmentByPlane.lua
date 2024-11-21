-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Number = LuauPolyfill.Number
local vec3 = require("../../../maths/vec3")
local function splitLineSegmentByPlane(plane, p1, p2)
	local direction = vec3.subtract(vec3.create(), p2, p1)
	local lambda = (
		plane[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		] - vec3.dot(plane, p1)
	) / vec3.dot(plane, direction)
	if Boolean.toJSBoolean(Number.isNaN(lambda)) then
		lambda = 0
	end
	if
		lambda
		> 1 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		lambda = 1
	end
	if
		lambda
		< 0 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		lambda = 0
	end
	vec3.scale(direction, direction, lambda)
	vec3.add(direction, p1, direction)
	return direction
end
return splitLineSegmentByPlane
