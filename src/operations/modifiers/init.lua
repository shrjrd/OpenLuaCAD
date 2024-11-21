-- ROBLOX NOTE: no upstream
--[[*
 * All shapes (primitives or the results of operations) can be modified to correct issues, etc.
 * In all cases, these functions returns the results, and never changes the original geometry.
 * @module modeling/modifiers
 * @example
 * const { snap } = require('@jscad/modeling').modifiers
 ]]
return {
	generalize = require("./generalize"),
	snap = require("./snap"),
	retessellate = require("./retessellate"),
}
