-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local area = require("../../../maths/utils").area
local toOutlines = require("../../../geometries/geom2").toOutlines
local arePointsInside = require("../../../geometries/poly2").arePointsInside
--[[
 * Find the item in the list with smallest score(item).
 * If the list is empty, return undefined.
 ]]
local function minIndex(list, score)
	local bestIndex
	local best
	Array.forEach(list, function(item, index)
		local value = score(item)
		if
			best == nil
			or value < best --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		then
			bestIndex = index
			best = value
		end
	end) --[[ ROBLOX CHECK: check if 'list' is an Array ]]
	return bestIndex
end
--[=[
 * Constructs a polygon hierarchy of solids and holes.
 * The hierarchy is represented as a forest of trees. All trees shall be depth at most 2.
 * If a solid exists inside the hole of another solid, it will be split out as its own root.
 *
 * @param {geom2} geometry
 * @returns {Array} an array of polygons with associated holes
 * @alias module:modeling/geometries/geom2.toTree
 *
 * @example
 * const geometry = subtract(rectangle({size: [5, 5]}), rectangle({size: [3, 3]}))
 * console.log(assignHoles(geometry))
 * [{
 *   "solid": [[-2.5,-2.5],[2.5,-2.5],[2.5,2.5],[-2.5,2.5]],
 *   "holes": [[[-1.5,1.5],[1.5,1.5],[1.5,-1.5],[-1.5,-1.5]]]
 * }]
 ]=]
local function assignHoles(geometry)
	local outlines = toOutlines(geometry)
	local solids = {} -- solid indices
	local holes = {} -- hole indices
	Array.forEach(outlines, function(outline, i)
		local a = area(outline)
		if
			a
			< 0 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		then
			table.insert(holes, i) --[[ ROBLOX CHECK: check if 'holes' is an Array ]]
		elseif
			a
			> 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		then
			table.insert(solids, i) --[[ ROBLOX CHECK: check if 'solids' is an Array ]]
		end
	end) --[[ ROBLOX CHECK: check if 'outlines' is an Array ]] -- for each hole, determine what solids it is inside of
	local children = {} -- child holes of solid[i]
	local parents = {} -- parent solids of hole[i]
	Array.forEach(solids, function(s, i)
		local solid = outlines[s]
		children[i] = {}
		Array.forEach(holes, function(h, j)
			local hole = outlines[h] -- check if a point of hole j is inside solid i
			if
				Boolean.toJSBoolean(arePointsInside({
					hole[
						1 --[[ ROBLOX adaptation: added 1 to array index ]]
					],
				}, { vertices = solid }))
			then
				table.insert(children[i], h) --[[ ROBLOX CHECK: check if 'children[i]' is an Array ]]
				if not Boolean.toJSBoolean(parents[j]) then
					parents[j] = {}
				end
				table.insert(parents[j], i) --[[ ROBLOX CHECK: check if 'parents[j]' is an Array ]]
			end
		end) --[[ ROBLOX CHECK: check if 'holes' is an Array ]]
	end) --[[ ROBLOX CHECK: check if 'solids' is an Array ]] -- check if holes have multiple parents and choose one with fewest children
	Array.forEach(holes, function(h, j)
		-- ensure at least one parent exists
		if
			Boolean.toJSBoolean(if Boolean.toJSBoolean(parents[j])
				then parents[j].length
					> 1 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
				else parents[j])
		then
			-- the solid directly containing this hole
			local directParent = minIndex(parents[j], function(p)
				return children[p].length
			end)
			Array.forEach(parents[j], function(p, i)
				if i ~= directParent then
					-- Remove hole from skip level parents
					children[p] = Array.filter(children[p], function(c)
						return c ~= h
					end) --[[ ROBLOX CHECK: check if 'children[p]' is an Array ]]
				end
			end) --[[ ROBLOX CHECK: check if 'parents[j]' is an Array ]]
		end
	end) --[[ ROBLOX CHECK: check if 'holes' is an Array ]] -- map indices back to points
	return Array.map(children, function(holes, i)
		return {
			solid = outlines[solids[i]],
			holes = Array.map(holes, function(h)
				return outlines[h]
			end),--[[ ROBLOX CHECK: check if 'holes' is an Array ]]
		}
	end) --[[ ROBLOX CHECK: check if 'children' is an Array ]]
end
return assignHoles
