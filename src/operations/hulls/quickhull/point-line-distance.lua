-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Error = LuauPolyfill.Error
local cross = require("../../../maths/vec3/cross")
local subtract = require("../../../maths/vec3/subtract")
local squaredLength = require("../../../maths/vec3/squaredLength")
--[[
 * Original source from quickhull3d (https://github.com/mauriciopoppe/quickhull3d)
 * Copyright (c) 2015 Mauricio Poppe
 *
 * Adapted to JSCAD by Jeff Gay
 ]]
local function distanceSquared(p, a, b)
	-- == parallelogram solution
	--
	--            s
	--      __a________b__
	--       /   |    /
	--      /   h|   /
	--     /_____|__/
	--    p
	--
	--  s = b - a
	--  area = s * h
	--  |ap x s| = s * h
	--  h = |ap x s| / s
	--
	local ab = {}
	local ap = {}
	local cr = {}
	subtract(ab, b, a)
	subtract(ap, p, a)
	local area = squaredLength(cross(cr, ap, ab))
	local s = squaredLength(ab)
	if s == 0 then
		error(Error.new("a and b are the same point"))
	end
	return area / s
end
local function pointLineDistance(point, a, b)
	return math.sqrt(distanceSquared(point, a, b))
end
return pointLineDistance
