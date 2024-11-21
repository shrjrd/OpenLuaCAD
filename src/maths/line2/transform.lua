-- ROBLOX NOTE: no upstream
local vec2 = require("../vec2")
local fromPoints = require("./fromPoints")
local origin = require("./origin")
local direction = require("./direction")
--[[*
 * Transforms the given line using the given matrix.
 *
 * @param {line2} out - receiving line
 * @param {line2} line - line to transform
 * @param {mat4} matrix - matrix to transform with
 * @returns {line2} out
 * @alias module:modeling/maths/line2.transform
 ]]
local function transform(out, line, matrix)
	local org = origin(line)
	local dir = direction(line)
	vec2.transform(org, org, matrix)
	vec2.transform(dir, dir, matrix)
	return fromPoints(out, org, dir)
end
return transform
