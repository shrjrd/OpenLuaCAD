-- ROBLOX NOTE: no upstream
--[[*
 * @module modeling/connectors
 ]]
return {
	create = require("./create"),
	-- extends: require('./extends'),
	fromPointAxisNormal = require("./fromPointAxisNormal"),
	-- normalize: require('./normalize'),
	toString = require("./toString"),
	transform = require("./transform"),
	transformationBetween = require("./transformationBetween"),
}
