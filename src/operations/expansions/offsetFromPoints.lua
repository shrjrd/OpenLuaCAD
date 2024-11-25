-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Map = LuauPolyfill.Map
local Number = LuauPolyfill.Number
local Object = LuauPolyfill.Object
local EPS, TAU
do
	local ref = require("../../maths/constants")
	EPS, TAU = ref.EPS, ref.TAU
end
local intersect = require("../../maths/utils/intersect")
local line2 = require("../../maths/line2")
local vec2 = require("../../maths/vec2")
local area = require("../../maths/utils/area")
--[[
 * Create a set of offset points from the given points using the given options (if any).
 * @param {Object} options - options for offset
 * @param {Float} [options.delta=1] - delta of offset (+ to exterior, - from interior)
 * @param {String} [options.corners='edge'] - type corner to create during of expansion; edge, chamfer, round
 * @param {Integer} [options.segments=16] - number of segments when creating round corners
 * @param {Integer} [options.closed=false] - is the last point connected back to the first point?
 * @param {Array} points - array of 2D points
 * @returns {Array} new set of offset points, plus points for each rounded corner
 ]]
local function offsetFromPoints(options, points)
	local defaults = { delta = 1, corners = "edge", closed = false, segments = 16 }
	local delta, corners, closed, segments
	do
		local ref = Object.assign({}, defaults, options)
		delta, corners, closed, segments = ref.delta, ref.corners, ref.closed, ref.segments
	end
	if
		math.abs(delta)
		< EPS --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		return points
	end
	local rotation = if Boolean.toJSBoolean(options.closed) then area(points) else 1.0 -- + counter clockwise, - clockwise
	if rotation == 0 then
		rotation = 1.0
	end -- use right hand normal?
	local orientation = rotation > 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
			and delta >= 0 --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
		or rotation < 0 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
			and delta < 0 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	delta = math.abs(delta) -- sign is no longer required
	local previousSegment = nil
	local newPoints = {}
	local newCorners = {}
	local of = vec2.create()
	local n = #points
	do
		local i = 0
		while
			i
			< n --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			local j = (i + 1) % n
			local p0 = points[i]
			local p1 = points[j] -- calculate the unit normal
			--error("not implemented") --[[ ROBLOX TODO: Lua doesn't support 'IfExpression' as a standalone type ]] --[[ orientation ? vec2.subtract(of, p0, p1) : vec2.subtract(of, p1, p0) ]]
			if orientation then
				vec2.subtract(of, p0, p1)
			else
				vec2.subtract(of, p1, p0)
			end
			vec2.normal(of, of)
			vec2.normalize(of, of) -- calculate the offset vector
			vec2.scale(of, of, delta) -- calculate the new points (edge)
			local n0 = vec2.add(vec2.create(), p0, of)
			local n1 = vec2.add(vec2.create(), p1, of)
			local currentSegment = { n0, n1 }
			if
				previousSegment ~= nil --[[ ROBLOX CHECK: loose inequality used upstream ]]
			then
				if
					Boolean.toJSBoolean(
						Boolean.toJSBoolean(closed) and closed or not Boolean.toJSBoolean(closed) and j ~= 0
					)
				then
					-- check for intersection of new line segments
					local ip = intersect(
						previousSegment[
							1 --[[ ROBLOX adaptation: added 1 to array index ]]
						],
						previousSegment[
							2 --[[ ROBLOX adaptation: added 1 to array index ]]
						],
						currentSegment[
							1 --[[ ROBLOX adaptation: added 1 to array index ]]
						],
						currentSegment[
							2 --[[ ROBLOX adaptation: added 1 to array index ]]
						]
					)
					if Boolean.toJSBoolean(ip) then
						-- adjust the previous points
						table.remove(newPoints) --[[ ROBLOX CHECK: check if 'newPoints' is an Array ]] -- adjust current points
						currentSegment[
							1 --[[ ROBLOX adaptation: added 1 to array index ]]
						] = ip
					else
						table.insert(newCorners, { c = p0, s0 = previousSegment, s1 = currentSegment }) --[[ ROBLOX CHECK: check if 'newCorners' is an Array ]]
					end
				end
			end
			previousSegment = { n0, n1 }
			if j == 0 and not Boolean.toJSBoolean(closed) then
				i += 1
				continue
			end
			table.insert(
				newPoints,
				currentSegment[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
			) --[[ ROBLOX CHECK: check if 'newPoints' is an Array ]]
			table.insert(
				newPoints,
				currentSegment[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
			) --[[ ROBLOX CHECK: check if 'newPoints' is an Array ]]
			i += 1
		end
	end -- complete the closure if required
	if
		Boolean.toJSBoolean(if Boolean.toJSBoolean(closed)
			then previousSegment ~= nil --[[ ROBLOX CHECK: loose inequality used upstream ]]
			else closed)
	then
		-- check for intersection of closing line segments
		local n0 = newPoints[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		local n1 = newPoints[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		local ip = intersect(
			previousSegment[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			previousSegment[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			n0,
			n1
		)
		if Boolean.toJSBoolean(ip) then
			-- adjust the previous points
			newPoints[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			] = ip
			table.remove(newPoints) --[[ ROBLOX CHECK: check if 'newPoints' is an Array ]]
		else
			local p0 = points[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			local cursegment = { n0, n1 }
			table.insert(newCorners, { c = p0, s0 = previousSegment, s1 = cursegment }) --[[ ROBLOX CHECK: check if 'newCorners' is an Array ]]
		end
	end -- generate corners if necessary
	if corners == "edge" then
		-- map for fast point index lookup
		local pointIndex = Map.new() -- {point: index}
		Array.forEach(newPoints, function(point, index)
			return pointIndex:set(point, index)
		end) --[[ ROBLOX CHECK: check if 'newPoints' is an Array ]] -- create edge corners
		local line0 = line2.create()
		local line1 = line2.create()
		Array.forEach(newCorners, function(corner)
			line2.fromPoints(
				line0,
				corner.s0[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				],
				corner.s0[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
			)
			line2.fromPoints(
				line1,
				corner.s1[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				],
				corner.s1[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
			)
			local ip = line2.intersectPointOfLines(line0, line1)
			if
				Boolean.toJSBoolean((function()
					local ref = Number.isFinite(ip[
						1 --[[ ROBLOX adaptation: added 1 to array index ]]
					])
					return if Boolean.toJSBoolean(ref)
						then Number.isFinite(ip[
							2 --[[ ROBLOX adaptation: added 1 to array index ]]
						])
						else ref
				end)())
			then
				local p0 = corner.s0[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
				local i = pointIndex:get(p0)
				newPoints[i] = ip
				newPoints[((i + 1) % #newPoints)] = nil
			else
				-- paralell segments, drop one
				local p0 = corner.s1[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
				local i = pointIndex:get(p0)
				newPoints[i] = nil
			end
		end) --[[ ROBLOX CHECK: check if 'newCorners' is an Array ]]
		newPoints = Array.filter(newPoints, function(p)
			return p ~= nil
		end) --[[ ROBLOX CHECK: check if 'newPoints' is an Array ]]
	end
	if corners == "round" then
		-- create rounded corners
		local cornersegments = math.floor(segments / 4)
		local v0 = vec2.create()
		Array.forEach(newCorners, function(corner)
			-- calculate angle of rotation
			local rotation = vec2.angle(vec2.subtract(
				v0,
				corner.s1[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				],
				corner.c
			))
			rotation -= vec2.angle(vec2.subtract(
				v0,
				corner.s0[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				],
				corner.c
			))
			if
				Boolean.toJSBoolean(if Boolean.toJSBoolean(orientation)
					then rotation
						< 0 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
					else orientation)
			then
				rotation = rotation + math.pi
				if
					rotation
					< 0 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
				then
					rotation = rotation + math.pi
				end
			end
			if
				not Boolean.toJSBoolean(orientation)
				and rotation > 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
			then
				rotation = rotation - math.pi
				if
					rotation
					> 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
				then
					rotation = rotation - math.pi
				end
			end
			if rotation ~= 0.0 then
				-- generate the segments
				cornersegments = math.floor(segments * (math.abs(rotation) / TAU))
				local step = rotation / cornersegments
				local start = vec2.angle(vec2.subtract(
					v0,
					corner.s0[
						2 --[[ ROBLOX adaptation: added 1 to array index ]]
					],
					corner.c
				))
				local cornerpoints = {}
				do
					local i = 1
					while
						i
						< cornersegments --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
					do
						local radians = start + step * i
						local point = vec2.fromAngleRadians(vec2.create(), radians)
						vec2.scale(point, point, delta)
						vec2.add(point, point, corner.c)
						table.insert(cornerpoints, point) --[[ ROBLOX CHECK: check if 'cornerpoints' is an Array ]]
						i += 1
					end
				end
				if
					#cornerpoints
					> 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
				then
					local p0 = corner.s0[
						2 --[[ ROBLOX adaptation: added 1 to array index ]]
					]
					local i = Array.findIndex(newPoints, function(point)
						return vec2.equals(p0, point)
					end) --[[ ROBLOX CHECK: check if 'newPoints' is an Array ]]
					i = (i + 1) % #newPoints
					Array.splice(
						newPoints,
						i,
						0,
						error("not implemented") --[[ ROBLOX TODO: Unhandled node for type: SpreadElement ]] --[[ ...cornerpoints ]]
					) --[[ ROBLOX CHECK: check if 'newPoints' is an Array ]]
				end
			else
				-- paralell segments, drop one
				local p0 = corner.s1[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
				local i = Array.findIndex(newPoints, function(point)
					return vec2.equals(p0, point)
				end) --[[ ROBLOX CHECK: check if 'newPoints' is an Array ]]
				Array.splice(newPoints, i, 1) --[[ ROBLOX CHECK: check if 'newPoints' is an Array ]]
			end
		end) --[[ ROBLOX CHECK: check if 'newCorners' is an Array ]]
	end
	return newPoints
end
return offsetFromPoints
