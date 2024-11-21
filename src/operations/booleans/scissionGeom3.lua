-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Map = LuauPolyfill.Map
local vec3 = require("../../maths/vec3")
local measureEpsilon = require("../../measurements/measureEpsilon")
local geom3 = require("../../geometries/geom3") -- returns array numerically sorted and duplicates removed
local function sortNb(array)
	return Array.filter(
		Array.sort(array, function(a, b)
			return a - b
		end), --[[ ROBLOX CHECK: check if 'array' is an Array ]]
		function(item, pos, ary)
			return not Boolean.toJSBoolean(pos) or item ~= ary[(pos - 1)]
		end
	)
end
local function insertMapping(map, point, index)
	local key = ("%s"):format(tostring(point))
	local mapping = map:get(key)
	if mapping == nil then
		map:set(key, { index })
	else
		table.insert(mapping, index) --[[ ROBLOX CHECK: check if 'mapping' is an Array ]]
	end
end
local function findMapping(map, point)
	local key = ("%s"):format(tostring(point))
	return map:get(key)
end
local function scissionGeom3(geometry)
	-- construit table de correspondance entre polygones
	-- build polygons lookup table
	local eps = measureEpsilon(geometry)
	local polygons = geom3.toPolygons(geometry)
	local pl = #polygons
	local indexesPerPoint = Map.new()
	local temp = vec3.create()
	Array.forEach(polygons, function(polygon, index)
		Array.forEach(polygon.vertices, function(point)
			insertMapping(indexesPerPoint, vec3.snap(temp, point, eps), index)
		end) --[[ ROBLOX CHECK: check if 'polygon.vertices' is an Array ]]
	end) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]]
	local indexesPerPolygon = Array.map(polygons, function(polygon)
		local indexes = {}
		Array.forEach(polygon.vertices, function(point)
			indexes = Array.concat(indexes, findMapping(indexesPerPoint, vec3.snap(temp, point, eps))) --[[ ROBLOX CHECK: check if 'indexes' is an Array ]]
		end) --[[ ROBLOX CHECK: check if 'polygon.vertices' is an Array ]]
		return { e = 1, d = sortNb(indexes) } -- for each polygon, push the list of indexes
	end) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]]
	indexesPerPoint:clear() -- regroupe les correspondances des polygones se touchant
	-- boucle ne s'arrêtant que quand deux passages retournent le même nb de polygones
	-- merge lookup data from linked polygons as long as possible
	local merges = 0
	local ippl = #indexesPerPolygon
	do
		local i = 0
		while
			i
			< ippl --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			local mapi = indexesPerPolygon[i] -- merge mappings if necessary
			if
				mapi.e
				> 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
			then
				local indexes = Array.new(pl)
				indexes[i] = true -- include ourself
				repeat
					merges = 0 -- loop through the known indexes
					Array.forEach(indexes, function(e, j)
						local mapj = indexesPerPolygon[j] -- merge this mapping if necessary
						if
							mapj.e
							> 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
						then
							mapj.e = -1 -- merged
							do
								local d = 0
								while
									d
									< #mapj.d --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
								do
									indexes[mapj.d[d]] = true
									d += 1
								end
							end
							merges += 1
						end
					end) --[[ ROBLOX CHECK: check if 'indexes' is an Array ]]
				until not (
						merges
						> 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
					)
				mapi.indexes = indexes
			end
			i += 1
		end
	end -- construit le tableau des geometry à retourner
	-- build array of geometry to return
	local newgeometries = {}
	do
		local i = 0
		while
			i
			< ippl --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			if Boolean.toJSBoolean(indexesPerPolygon[i].indexes) then
				local newpolygons = {}
				Array.forEach(indexesPerPolygon[i].indexes, function(e, p)
					return table.insert(newpolygons, polygons[p]) --[[ ROBLOX CHECK: check if 'newpolygons' is an Array ]]
				end) --[[ ROBLOX CHECK: check if 'indexesPerPolygon[i].indexes' is an Array ]]
				table.insert(newgeometries, geom3.create(newpolygons)) --[[ ROBLOX CHECK: check if 'newgeometries' is an Array ]]
			end
			i += 1
		end
	end
	return newgeometries
end
return scissionGeom3
