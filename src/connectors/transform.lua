-- ROBLOX NOTE: no upstream
local vec3 = require("../maths/vec3")
local fromPointAxisNormal = require("./fromPointAxisNormal")
--[[*
 * Transform the give connector using the given matrix.
 * @param {mat4} matrix - a transform matrix
 * @param {connector} connector - the connector to transform
 * @returns {connector} a new connector
 * @alias module:modeling/connectors.transform
 ]]
local function transform(matrix, connector)
	-- OPTIMIZE
	local newpoint = vec3.transform(vec3.create(), connector.point, matrix)
	local newaxis = vec3.subtract(
		vec3.create(),
		vec3.transform(vec3.create(), vec3.add(vec3.create(), connector.point, connector.axis), matrix),
		newpoint
	)
	local newnormal = vec3.subtract(
		vec3.create(),
		vec3.transform(vec3.create(), vec3.add(vec3.create(), connector.point, connector.normal), matrix),
		newpoint
	)
	return fromPointAxisNormal(newpoint, newaxis, newnormal)
end
return transform
