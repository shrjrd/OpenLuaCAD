-- ROBLOX NOTE: no upstream
--local Packages = game.ReplicatedStorage.Packages
--local LuauPolyfill = require(Packages.LuauPolyfill)
--type Object = LuauPolyfill.Object
local QuickHull = require("./QuickHull")
--[[
 * Original source from quickhull3d (https://github.com/mauriciopoppe/quickhull3d)
 * Copyright (c) 2015 Mauricio Poppe
 *
 * Adapted to JSCAD by Jeff Gay
 ]]
local function runner(points, options_) --: Object?)
	local options = options_ or {} --local options: Object = if options_ ~= nil then options_ else {}
	local instance = QuickHull.new(points)
	instance:build()
	return instance:collectFaces(options.skipTriangulation)
end
return runner
