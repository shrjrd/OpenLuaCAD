-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local Number_EPSILON = 2.220446049250313e-16
local Number_MAX_VALUE = 1.7976931348623157e+308
local LuauPolyfill = require(Packages.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Number = LuauPolyfill.Number
-- Compare two numeric values for near equality.
-- the given test is fails if the numeric values are outside the given epsilon
local function nearlyEqual(a, b, epsilon, failMessage)
	--	if typeof(t) ~= "table" then
	--		error(Error.new("first argument must be a test object"))
	--	end
	if a == b then
		-- shortcut, also handles infinities
		return true
	end
	local absA = math.abs(a)
	local absB = math.abs(b)
	local diff = math.abs(a - b)
	if Boolean.toJSBoolean(Number.isNaN(diff)) then
		failMessage = if failMessage == nil then "difference is not a number" else failMessage
		error(Error.new(tostring(failMessage) .. "(" .. tostring(a) .. "," .. tostring(b) .. ")")) -- t:fail()
	end
	if
		a == 0
		or b == 0
		or diff < Number_EPSILON --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		-- a or b is zero or both are extremely close to it
		-- relative error is less meaningful here
		if
			diff
			> epsilon * Number_EPSILON --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		then
			failMessage = if failMessage == nil then "near zero Numbers outside of epsilon" else failMessage
			error(Error.new(tostring(failMessage) .. "(" .. tostring(a) .. "," .. tostring(b) .. ")")) -- t:fail()
		end
	end -- use relative error
	local relative = diff / math.min(absA + absB, Number_MAX_VALUE)
	if
		relative
		> epsilon --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		failMessage = if failMessage == nil then "Numbers outside of epsilon" else failMessage
		error(Error.new(tostring(failMessage) .. "(" .. tostring(a) .. "," .. tostring(b) .. ")")) -- t:fail(tostring(failMessage) .. "(" .. tostring(a) .. "," .. tostring(b) .. ")")
	end
	return
end
return nearlyEqual
