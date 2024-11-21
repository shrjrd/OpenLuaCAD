-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
--[[*
 * Insert the given element into the given array using the compareFunction.
 * @alias module:modeling/utils.insertSorted
 ]]
local function insertSorted(array, element, comparefunc)
	local leftbound = 0
	local rightbound = #array
	while
		rightbound
		> leftbound --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	do
		local testindex = math.floor((leftbound + rightbound) / 2)
		local testelement = array[testindex]
		local compareresult = comparefunc(element, testelement)
		if
			compareresult
			> 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		then
			-- element > testelement
			leftbound = testindex + 1
		else
			rightbound = testindex
		end
	end
	Array.splice(array, leftbound, 0, element) --[[ ROBLOX CHECK: check if 'array' is an Array ]]
end
return insertSorted
