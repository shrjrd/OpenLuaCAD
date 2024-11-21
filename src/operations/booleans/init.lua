-- ROBLOX NOTE: no upstream
--[[*
 * All shapes (primitives or the results of operations) can be passed to boolean functions
 * to perform logical operations, e.g. remove a hole from a board.
 * In all cases, the function returns the results, and never changes the original shapes.
 * @module modeling/booleans
 * @example
 * const { intersect, subtract, union } = require('@jscad/modeling').booleans
 ]]
return {
	intersect = require("./intersect"),
	scission = require("./scission"),
	subtract = require("./subtract"),
	union = require("./union"),
}
