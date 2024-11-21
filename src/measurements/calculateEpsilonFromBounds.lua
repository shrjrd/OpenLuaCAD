-- ROBLOX NOTE: no upstream
local EPS = require("../maths/constants").EPS
local function calculateEpsilonFromBounds(bounds, dimensions)
	local total = 0
	do
		local i = 0
		while
			i
			< dimensions --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			total += bounds[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			][i] - bounds[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			][i]
			i += 1
		end
	end
	return EPS * total / dimensions
end
return calculateEpsilonFromBounds
