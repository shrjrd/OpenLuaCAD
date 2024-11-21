-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local mat4 = require("../maths/mat4")
local plane = require("../maths/plane")
local vec2 = require("../maths/vec2")
local vec3 = require("../maths/vec3")
local OrthoNormalBasis = require("../maths/OrthoNormalBasis")
local transform = require("./transform")
--[[*
 * Get the transformation matrix that connects the given connectors.
 * @param {Object} options
 * @param {Boolean} [options.mirror=false] - the 'axis' vectors should point in the same direction
 *  true: the 'axis' vectors should point in opposite direction
 * @param {Number} [options.normalRotation=0] - the angle (RADIANS) of rotation between the 'normal' vectors
 * @param {connector} from - connector from which to connect
 * @param {connector} to - connector to which to connected
 * @returns {mat4} - the matrix that transforms (connects) one connector to another
 * @alias module:modeling/connectors.transformationBetween
 ]]
local function transformationBetween(options, from, to)
	local defaults = { mirror = false, normalRotation = 0 } -- mirror = !!mirror
	local mirror, normalRotation
	do
		local ref = Object.assign({}, defaults, options)
		mirror, normalRotation = ref.mirror, ref.normalRotation
	end -- shift to the 0,0 origin
	local matrix = mat4.fromTranslation(mat4.create(), vec3.negate(vec3.create(), from.point)) -- align the axis
	local axesplane = plane.fromPointsRandom(plane.create(), vec3.create(), from.axis, to.axis)
	local axesbasis = OrthoNormalBasis.new(axesplane)
	local angle1 = vec2.angleRadians(axesbasis:to2D(from.axis))
	local angle2 = vec2.angleRadians(axesbasis:to2D(to.axis))
	local rotation = angle2 - angle1
	if Boolean.toJSBoolean(mirror) then
		rotation += math.pi
	end -- 180 degrees
	-- TODO: understand and explain this
	mat4.multiply(matrix, matrix, axesbasis:getProjectionMatrix())
	mat4.multiply(matrix, matrix, mat4.fromZRotation(mat4.create(), rotation))
	mat4.multiply(matrix, matrix, axesbasis:getInverseProjectionMatrix())
	local usAxesAligned = transform(matrix, from) -- Now we have done the transformation for aligning the axes.
	-- align the normals
	local normalsplane = plane.fromNormalAndPoint(plane.create(), to.axis, vec3.create())
	local normalsbasis = OrthoNormalBasis.new(normalsplane)
	angle1 = vec2.angleRadians(normalsbasis:to2D(usAxesAligned.normal))
	angle2 = vec2.angleRadians(normalsbasis:to2D(to.normal))
	rotation = angle2 - angle1 + normalRotation
	mat4.multiply(matrix, matrix, normalsbasis:getProjectionMatrix())
	mat4.multiply(matrix, matrix, mat4.fromZRotation(mat4.create(), rotation))
	mat4.multiply(matrix, matrix, normalsbasis:getInverseProjectionMatrix()) -- translate to the destination point
	mat4.multiply(matrix, matrix, mat4.fromTranslation(mat4.create(), to.point))
	return matrix
end
return transformationBetween
