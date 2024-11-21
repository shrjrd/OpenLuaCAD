-- ROBLOX NOTE: no upstream
--[[*
 * Return a string representing the given connector.
 *
 * @param {connector} connector - the connector of reference
 * @returns {string} string representation
 * @alias module:modeling/connectors.toString
 ]]
local function toString(connector)
	local point = connector.point
	local axis = connector.axis
	local normal = connector.normal
	return ("connector: point: [%s, %s, %s],  axis: [%s, %s, %s], normal: [%s, %s, %s]"):format(
		tostring(point[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]:toFixed(7)),
		tostring(point[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]:toFixed(7)),
		tostring(point[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]:toFixed(7)),
		tostring(axis[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]:toFixed(7)),
		tostring(axis[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]:toFixed(7)),
		tostring(axis[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]:toFixed(7)),
		tostring(normal[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]:toFixed(7)),
		tostring(normal[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]:toFixed(7)),
		tostring(normal[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]:toFixed(7))
	)
end
return toString
