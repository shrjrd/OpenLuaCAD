-- ROBLOX NOTE: no upstream
local vec3 = require("../maths/vec3")
local create = require("./create")
--[[*
 * Create a connector from the given point, axis and normal.
 * @param {vec3} point - the point of the connector, relative to the parent geometry
 * @param {vec3} axis - the axis (directional vector) of the connector
 * @param {vec3} normal - the normal (directional vector) of the connector, perpendicular to the axis
 * @returns {connector} a new connector
 * @alias module:modeling/connectors.fromPointsAxisNormal
 ]]
local function fromPointAxisNormal(point, axis, normal)
	local connector = create()
	connector.point = vec3.clone(point)
	connector.axis = vec3.normalize(vec3.create(), axis)
	connector.normal = vec3.normalize(vec3.create(), normal)
	return connector
end
return fromPointAxisNormal