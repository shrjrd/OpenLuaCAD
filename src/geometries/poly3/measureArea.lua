-- ROBLOX NOTE: no upstream
local plane = require("./plane")
--[[*
 * Measure the area of the given polygon.
 * @see 2000 softSurfer http://geomalgorithms.com
 * @param {poly3} polygon - the polygon to measure
 * @return {Number} area of the polygon
 * @alias module:modeling/geometries/poly3.measureArea
 ]]
local function measureArea(polygon)
	local n = #polygon.vertices
	if
		n < 3 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		return 0 -- degenerate polygon
	end
	local vertices = polygon.vertices -- calculate a normal vector
	local normal = plane(polygon) -- determine direction of projection
	local ax = math.abs(normal[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	])
	local ay = math.abs(normal[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	])
	local az = math.abs(normal[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	])
	if ax + ay + az == 0 then
		-- normal does not exist
		return 0
	end
	local coord = 3 -- ignore Z coordinates
	if
		ax > ay --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		and ax > az --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		coord = 1 -- ignore X coordinates
	elseif
		ay
		> az --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		coord = 2 -- ignore Y coordinates
	end
	local area = 0
	local h = 0
	local i = 1
	local j = 2
	repeat --[[ ROBLOX comment: switch statement conversion ]]
		local entered_, break_ = false, false
		local condition_ = coord
		for _, v in ipairs({ 1, 2, 3 }) do
			if condition_ == v then
				if v == 1 then
					entered_ = true
					-- ignore X coordinates
					-- compute area of 2D projection
					-- ignore X coordinates
					-- compute area of 2D projection
					i = 1
					while
						i
						< n --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
					do
						h = i - 1
						j = (i + 1) % n
						area += vertices[i][
							2 --[[ ROBLOX adaptation: added 1 to array index ]]
						] * (vertices[j][
							3 --[[ ROBLOX adaptation: added 1 to array index ]]
						] - vertices[h][
							3 --[[ ROBLOX adaptation: added 1 to array index ]]
						])
						i += 1
					end
					area += vertices[
						1 --[[ ROBLOX adaptation: added 1 to array index ]]
					][
						2 --[[ ROBLOX adaptation: added 1 to array index ]]
					] * (vertices[
						2 --[[ ROBLOX adaptation: added 1 to array index ]]
					][
						3 --[[ ROBLOX adaptation: added 1 to array index ]]
					] - vertices[(n - 1)][
						3 --[[ ROBLOX adaptation: added 1 to array index ]]
					]) -- scale to get area -- scale to get area
					area /= 2 * normal[
						1 --[[ ROBLOX adaptation: added 1 to array index ]]
					]
					break_ = true
					break
				end
				if v == 2 or entered_ then
					entered_ = true
					-- ignore Y coordinates
					-- compute area of 2D projection
					-- ignore Y coordinates
					-- compute area of 2D projection
					i = 1
					while
						i
						< n --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
					do
						h = i - 1
						j = (i + 1) % n
						area += vertices[i][
							3 --[[ ROBLOX adaptation: added 1 to array index ]]
						] * (vertices[j][
							1 --[[ ROBLOX adaptation: added 1 to array index ]]
						] - vertices[h][
							1 --[[ ROBLOX adaptation: added 1 to array index ]]
						])
						i += 1
					end
					area += vertices[
						1 --[[ ROBLOX adaptation: added 1 to array index ]]
					][
						3 --[[ ROBLOX adaptation: added 1 to array index ]]
					] * (vertices[
						2 --[[ ROBLOX adaptation: added 1 to array index ]]
					][
						1 --[[ ROBLOX adaptation: added 1 to array index ]]
					] - vertices[(n - 1)][
						1 --[[ ROBLOX adaptation: added 1 to array index ]]
					]) -- scale to get area -- scale to get area
					area /= 2 * normal[
						2 --[[ ROBLOX adaptation: added 1 to array index ]]
					]
					break_ = true
					break
				end
				if v == 3 or entered_ then
					entered_ = true
				end
			end
		end
		if not break_ then
			-- compute area of 2D projection
			i = 1
			while
				i
				< n --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
			do
				h = i - 1
				j = (i + 1) % n
				area += vertices[i][
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				] * (vertices[j][
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				] - vertices[h][
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				])
				i += 1
			end
			area += vertices[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			][
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			] * (vertices[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			][
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			] - vertices[(n - 1)][
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			]) -- scale to get area
			area /= 2 * normal[
				3 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			break
		end
	until true
	return area
end
return measureArea
