-- ROBLOX NOTE: no upstream
--[[*
 * All shapes (primitives or the results of operations) can be expanded (or contracted.)
 * In all cases, the function returns the results, and never changes the original shapes.
 * @module modeling/expansions
 * @example
 * const { expand, offset } = require('@jscad/modeling').expansions
 ]]
return { expand = require("./expand"), offset = require("./offset") }
