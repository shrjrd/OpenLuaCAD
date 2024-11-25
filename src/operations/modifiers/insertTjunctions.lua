-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Map = LuauPolyfill.Map
local console = LuauPolyfill.console
local constants = require("../../maths/constants")
local vec3 = require("../../maths/vec3")
local poly3 = require("../../geometries/poly3")
local assert_ = false
local function getTag(vertex)
	return ("%s"):format(tostring(vertex))
end
local function deleteSide(sidemap, vertextag2sidestart, vertextag2sideend, vertex0, vertex1, polygonindex)
	local starttag = getTag(vertex0)
	local endtag = getTag(vertex1)
	local sidetag = ("%s/%s"):format(tostring(starttag), tostring(endtag))
	if
		Boolean.toJSBoolean(
			if Boolean.toJSBoolean(assert_) then not Boolean.toJSBoolean(sidemap:has(sidetag)) else assert_
		)
	then
		error(Error.new("assert failed"))
	end
	local idx = -1
	local sideobjs = sidemap:get(sidetag)
	do
		local i = 0
		while
			i
			< sideobjs.length --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			local sideobj = sideobjs[tostring(i)]
			sidetag = getTag(sideobj.vertex0)
			if sidetag ~= starttag then
				i += 1
				continue
			end
			sidetag = getTag(sideobj.vertex1)
			if sidetag ~= endtag then
				i += 1
				continue
			end
			if polygonindex ~= nil then
				if sideobj.polygonindex ~= polygonindex then
					i += 1
					continue
				end
			end
			idx = i
			break
		end
	end
	if
		Boolean.toJSBoolean(if Boolean.toJSBoolean(assert_)
			then idx
				< 0 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
			else assert_)
	then
		error(Error.new("assert failed"))
	end
	Array.splice(sideobjs, idx, 1) --[[ ROBLOX CHECK: check if 'sideobjs' is an Array ]]
	if sideobjs.length == 0 then
		sidemap:delete(sidetag)
	end -- adjust start and end lists
	idx = Array.indexOf(vertextag2sidestart:get(starttag), sidetag) --[[ ROBLOX CHECK: check if 'vertextag2sidestart.get(starttag)' is an Array ]]
	if
		Boolean.toJSBoolean(if Boolean.toJSBoolean(assert_)
			then idx
				< 0 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
			else assert_)
	then
		error(Error.new("assert failed"))
	end
	Array.splice(vertextag2sidestart:get(starttag), idx, 1) --[[ ROBLOX CHECK: check if 'vertextag2sidestart.get(starttag)' is an Array ]]
	if vertextag2sidestart:get(starttag).length == 0 then
		vertextag2sidestart:delete(starttag)
	end
	idx = Array.indexOf(vertextag2sideend:get(endtag), sidetag) --[[ ROBLOX CHECK: check if 'vertextag2sideend.get(endtag)' is an Array ]]
	if
		Boolean.toJSBoolean(if Boolean.toJSBoolean(assert_)
			then idx
				< 0 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
			else assert_)
	then
		error(Error.new("assert failed"))
	end
	Array.splice(vertextag2sideend:get(endtag), idx, 1) --[[ ROBLOX CHECK: check if 'vertextag2sideend.get(endtag)' is an Array ]]
	if vertextag2sideend:get(endtag).length == 0 then
		vertextag2sideend:delete(endtag)
	end
end
local function addSide(sidemap, vertextag2sidestart, vertextag2sideend, vertex0, vertex1, polygonindex)
	local starttag = getTag(vertex0)
	local endtag = getTag(vertex1)
	if Boolean.toJSBoolean(if Boolean.toJSBoolean(assert_) then starttag == endtag else assert_) then
		error(Error.new("assert failed"))
	end
	local newsidetag = ("%s/%s"):format(tostring(starttag), tostring(endtag))
	local reversesidetag = ("%s/%s"):format(tostring(endtag), tostring(starttag))
	if Boolean.toJSBoolean(sidemap:has(reversesidetag)) then
		-- remove the opposing side from mappings
		deleteSide(sidemap, vertextag2sidestart, vertextag2sideend, vertex1, vertex0, nil)
		return nil
	end -- add the side to the mappings
	local newsideobj = { vertex0 = vertex0, vertex1 = vertex1, polygonindex = polygonindex }
	if not Boolean.toJSBoolean(sidemap:has(newsidetag)) then
		sidemap:set(newsidetag, { newsideobj })
	else
		table.insert(sidemap:get(newsidetag), newsideobj) --[[ ROBLOX CHECK: check if 'sidemap.get(newsidetag)' is an Array ]]
	end
	if Boolean.toJSBoolean(vertextag2sidestart:has(starttag)) then
		table.insert(vertextag2sidestart:get(starttag), newsidetag) --[[ ROBLOX CHECK: check if 'vertextag2sidestart.get(starttag)' is an Array ]]
	else
		vertextag2sidestart:set(starttag, { newsidetag })
	end
	if Boolean.toJSBoolean(vertextag2sideend:has(endtag)) then
		table.insert(vertextag2sideend:get(endtag), newsidetag) --[[ ROBLOX CHECK: check if 'vertextag2sideend.get(endtag)' is an Array ]]
	else
		vertextag2sideend:set(endtag, { newsidetag })
	end
	return newsidetag
end
--[[
  Suppose we have two polygons ACDB and EDGF:

   A-----B
   |     |
   |     E--F
   |     |  |
   C-----D--G

  Note that vertex E forms a T-junction on the side BD. In this case some STL slicers will complain
  that the solid is not watertight. This is because the watertightness check is done by checking if
  each side DE is matched by another side ED.

  This function will return a new solid with ACDB replaced by ACDEB

  Note that this can create polygons that are slightly non-convex (due to rounding errors). Therefore the result should
  not be used for further CSG operations!

  Note this function is meant to be used to preprocess geometries when triangulation is required, i.e. AMF, STL, etc.
  Do not use the results in other operations.
]]
--[[
 * Insert missing vertices for T junctions, which creates polygons that can be triangulated.
 * @param {Array} polygons - the original polygons which may or may not have T junctions
 * @return original polygons (if no T junctions found) or new polygons with updated vertices
 ]]
local function insertTjunctions(polygons)
	-- STEP 1 : build a map of 'unmatched' sides from the polygons
	-- i.e. side AB in one polygon does not have a matching side BA in another polygon
	local sidemap = Map.new()
	do
		local polygonindex = 0
		while
			polygonindex
			< polygons.length --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			local polygon = polygons[tostring(polygonindex)]
			local numvertices = polygon.vertices.length
			if
				numvertices
				>= 3 --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
			then
				local vertex = polygon.vertices[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
				local vertextag = getTag(vertex)
				do
					local vertexindex = 0
					while
						vertexindex
						< numvertices --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
					do
						local nextvertexindex = vertexindex + 1
						if nextvertexindex == numvertices then
							nextvertexindex = 0
						end
						local nextvertex = polygon.vertices[tostring(nextvertexindex)]
						local nextvertextag = getTag(nextvertex)
						local sidetag = ("%s/%s"):format(tostring(vertextag), tostring(nextvertextag))
						local reversesidetag = ("%s/%s"):format(tostring(nextvertextag), tostring(vertextag))
						if Boolean.toJSBoolean(sidemap:has(reversesidetag)) then
							-- this side matches the same side in another polygon. Remove from sidemap
							-- FIXME is this check necessary? there should only be ONE(1) opposing side
							-- FIXME assert ?
							local ar = sidemap:get(reversesidetag)
							Array.splice(ar, -1, 1) --[[ ROBLOX CHECK: check if 'ar' is an Array ]]
							if ar.length == 0 then
								sidemap:delete(reversesidetag)
							end
						else
							local sideobj = { vertex0 = vertex, vertex1 = nextvertex, polygonindex = polygonindex }
							if not Boolean.toJSBoolean(sidemap:has(sidetag)) then
								sidemap:set(sidetag, { sideobj })
							else
								table.insert(sidemap:get(sidetag), sideobj) --[[ ROBLOX CHECK: check if 'sidemap.get(sidetag)' is an Array ]]
							end
						end
						vertex = nextvertex
						vertextag = nextvertextag
						vertexindex += 1
					end
				end
			else
				console.warn("warning: invalid polygon found during insertTjunctions")
			end
			polygonindex += 1
		end
	end
	if
		sidemap.size
		> 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		-- STEP 2 : create a list of starting sides and ending sides
		local vertextag2sidestart = Map.new()
		local vertextag2sideend = Map.new()
		local sidesToCheck = Map.new()
		for _, ref in sidemap do
			local sidetag, sideobjs = table.unpack(ref, 1, 2)
			sidesToCheck:set(sidetag, true)
			Array.forEach(sideobjs, function(sideobj)
				local starttag = getTag(sideobj.vertex0)
				local endtag = getTag(sideobj.vertex1)
				if Boolean.toJSBoolean(vertextag2sidestart:has(starttag)) then
					table.insert(vertextag2sidestart:get(starttag), sidetag) --[[ ROBLOX CHECK: check if 'vertextag2sidestart.get(starttag)' is an Array ]]
				else
					vertextag2sidestart:set(starttag, { sidetag })
				end
				if Boolean.toJSBoolean(vertextag2sideend:has(endtag)) then
					table.insert(vertextag2sideend:get(endtag), sidetag) --[[ ROBLOX CHECK: check if 'vertextag2sideend.get(endtag)' is an Array ]]
				else
					vertextag2sideend:set(endtag, { sidetag })
				end
			end) --[[ ROBLOX CHECK: check if 'sideobjs' is an Array ]]
		end -- STEP 3 : if sidemap is not empty
		local newpolygons = Array.slice(polygons, 0) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]] -- make a copy in order to replace polygons inline
		while true do
			if sidemap.size == 0 then
				break
			end
			for _, sidetag in sidemap:keys() do
				sidesToCheck:set(sidetag, true)
			end
			local donesomething = false
			while true do
				local sidetags = Array.from(sidesToCheck:keys())
				if sidetags.length == 0 then
					break
				end -- sidesToCheck is empty, we're done!
				local sidetagtocheck = sidetags[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
				local donewithside = true
				if Boolean.toJSBoolean(sidemap:has(sidetagtocheck)) then
					local sideobjs = sidemap:get(sidetagtocheck)
					if Boolean.toJSBoolean(if Boolean.toJSBoolean(assert_) then sideobjs.length == 0 else assert_) then
						error(Error.new("assert failed"))
					end
					local sideobj = sideobjs[
						1 --[[ ROBLOX adaptation: added 1 to array index ]]
					]
					do
						local directionindex = 0
						while
							directionindex
							< 2 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
						do
							local startvertex = if directionindex == 0 then sideobj.vertex0 else sideobj.vertex1
							local endvertex = if directionindex == 0 then sideobj.vertex1 else sideobj.vertex0
							local startvertextag = getTag(startvertex)
							local endvertextag = getTag(endvertex)
							local matchingsides = {}
							if directionindex == 0 then
								if Boolean.toJSBoolean(vertextag2sideend:has(startvertextag)) then
									matchingsides = vertextag2sideend:get(startvertextag)
								end
							else
								if Boolean.toJSBoolean(vertextag2sidestart:has(startvertextag)) then
									matchingsides = vertextag2sidestart:get(startvertextag)
								end
							end
							do
								local matchingsideindex = 0
								while
									matchingsideindex
									< #matchingsides --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
								do
									local matchingsidetag = matchingsides[tostring(matchingsideindex)]
									local matchingside = sidemap:get(matchingsidetag)[
										1 --[[ ROBLOX adaptation: added 1 to array index ]]
									]
									local matchingsidestartvertex = if directionindex == 0
										then matchingside.vertex0
										else matchingside.vertex1
									local matchingsideendvertex = if directionindex == 0
										then matchingside.vertex1
										else matchingside.vertex0
									local matchingsidestartvertextag = getTag(matchingsidestartvertex)
									local matchingsideendvertextag = getTag(matchingsideendvertex)
									if
										Boolean.toJSBoolean(
											if Boolean.toJSBoolean(assert_)
												then matchingsideendvertextag ~= startvertextag
												else assert_
										)
									then
										error(Error.new("assert failed"))
									end
									if matchingsidestartvertextag == endvertextag then
										-- matchingside cancels sidetagtocheck
										deleteSide(
											sidemap,
											vertextag2sidestart,
											vertextag2sideend,
											startvertex,
											endvertex,
											nil
										)
										deleteSide(
											sidemap,
											vertextag2sidestart,
											vertextag2sideend,
											endvertex,
											startvertex,
											nil
										)
										donewithside = false
										directionindex = 2 -- skip reverse direction check
										donesomething = true
										break
									else
										local startpos = startvertex
										local endpos = endvertex
										local checkpos = matchingsidestartvertex
										local direction = vec3.subtract(vec3.create(), checkpos, startpos) -- Now we need to check if endpos is on the line startpos-checkpos:
										local t = vec3.dot(vec3.subtract(vec3.create(), endpos, startpos), direction)
											/ vec3.dot(direction, direction)
										if
											t > 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
											and t < 1 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
										then
											local closestpoint = vec3.scale(vec3.create(), direction, t)
											vec3.add(closestpoint, closestpoint, startpos)
											local distancesquared = vec3.squaredDistance(closestpoint, endpos)
											if
												distancesquared
												< constants.EPS * constants.EPS --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
											then
												-- Yes it's a t-junction! We need to split matchingside in two:
												local polygonindex = matchingside.polygonindex
												local polygon = newpolygons[tostring(polygonindex)] -- find the index of startvertextag in polygon:
												local insertionvertextag = getTag(matchingside.vertex1)
												local insertionvertextagindex = -1
												do
													local i = 0
													while
														i
														< polygon.vertices.length --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
													do
														if
															getTag(polygon.vertices[tostring(i)]) == insertionvertextag
														then
															insertionvertextagindex = i
															break
														end
														i += 1
													end
												end
												if
													Boolean.toJSBoolean(if Boolean.toJSBoolean(assert_)
														then insertionvertextagindex
															< 0 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
														else assert_)
												then
													error(Error.new("assert failed"))
												end -- split the side by inserting the vertex:
												local newvertices = Array.slice(polygon.vertices, 0) --[[ ROBLOX CHECK: check if 'polygon.vertices' is an Array ]]
												Array.splice(newvertices, insertionvertextagindex, 0, endvertex) --[[ ROBLOX CHECK: check if 'newvertices' is an Array ]]
												local newpolygon = poly3.create(newvertices)
												newpolygons[tostring(polygonindex)] = newpolygon -- remove the original sides from our maps
												deleteSide(
													sidemap,
													vertextag2sidestart,
													vertextag2sideend,
													matchingside.vertex0,
													matchingside.vertex1,
													polygonindex
												)
												local newsidetag1 = addSide(
													sidemap,
													vertextag2sidestart,
													vertextag2sideend,
													matchingside.vertex0,
													endvertex,
													polygonindex
												)
												local newsidetag2 = addSide(
													sidemap,
													vertextag2sidestart,
													vertextag2sideend,
													endvertex,
													matchingside.vertex1,
													polygonindex
												)
												if newsidetag1 ~= nil then
													sidesToCheck:set(newsidetag1, true)
												end
												if newsidetag2 ~= nil then
													sidesToCheck:set(newsidetag2, true)
												end
												donewithside = false
												directionindex = 2 -- skip reverse direction check
												donesomething = true
												break
											end -- if(distancesquared < 1e-10)
										end -- if( (t > 0) && (t < 1) )
									end -- if(endingstidestartvertextag === endvertextag)
									matchingsideindex += 1
								end
							end -- for matchingsideindex
							directionindex += 1
						end
					end -- for directionindex
				end -- if(sidetagtocheck in sidemap)
				if Boolean.toJSBoolean(donewithside) then
					sidesToCheck:delete(sidetagtocheck)
				end
			end
			if not Boolean.toJSBoolean(donesomething) then
				break
			end
		end
		polygons = newpolygons
	end
	sidemap:clear()
	return polygons
end
return insertTjunctions
