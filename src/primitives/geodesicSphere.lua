-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object
local mat4 = require("../maths/mat4")
local vec3 = require("../maths/vec3")
local geom3 = require("../geometries/geom3")
local polyhedron = require("./polyhedron")
local isGTE = require("./commonChecks").isGTE
--[[*
 * Construct a geodesic sphere based on icosahedron symmetry.
 * @param {Object} [options] - options for construction
 * @param {Number} [options.radius=1] - target radius of sphere
 * @param {Number} [options.frequency=6] - subdivision frequency per face, multiples of 6
 * @returns {geom3} new 3D geometry
 * @alias module:modeling/primitives.geodesicSphere
 *
 * @example
 * let myshape = geodesicSphere({radius: 15, frequency: 18})
 ]]
local function geodesicSphere(options)
	local defaults = { radius = 1, frequency = 6 }
	local radius, frequency
	do
		local ref = Object.assign({}, defaults, options)
		radius, frequency = ref.radius, ref.frequency
	end
	if not Boolean.toJSBoolean(isGTE(radius, 0)) then
		error(Error.new("radius must be positive"))
	end
	if not Boolean.toJSBoolean(isGTE(frequency, 6)) then
		error(Error.new("frequency must be six or more"))
	end -- if radius is zero return empty geometry
	if radius == 0 then
		return geom3.create()
	end -- adjust the frequency to base 6
	frequency = math.floor(frequency / 6)
	local ci = {
		-- hard-coded data of icosahedron (20 faces, all triangles)
		-- hard-coded data of icosahedron (20 faces, all triangles)
		{ 0.850651, 0.000000, -0.525731 },
		{ 0.850651, -0.000000, 0.525731 },
		{ -0.850651, -0.000000, 0.525731 },
		{ -0.850651, 0.000000, -0.525731 },
		{ 0.000000, -0.525731, 0.850651 },
		{ 0.000000, 0.525731, 0.850651 },
		{ 0.000000, 0.525731, -0.850651 },
		{ 0.000000, -0.525731, -0.850651 },
		{ -0.525731, -0.850651, -0.000000 },
		{ 0.525731, -0.850651, -0.000000 },
		{ 0.525731, 0.850651, 0.000000 },
		{ -0.525731, 0.850651, 0.000000 },
	}
	local ti = {
		{ 0, 9, 1 },
		{ 1, 10, 0 },
		{ 6, 7, 0 },
		{ 10, 6, 0 },
		{ 7, 9, 0 },
		{ 5, 1, 4 },
		{ 4, 1, 9 },
		{ 5, 10, 1 },
		{ 2, 8, 3 },
		{ 3, 11, 2 },
		{ 2, 5, 4 },
		{ 4, 8, 2 },
		{ 2, 11, 5 },
		{ 3, 7, 6 },
		{ 6, 11, 3 },
		{ 8, 7, 3 },
		{ 9, 8, 4 },
		{ 11, 10, 5 },
		{ 10, 11, 6 },
		{ 8, 9, 7 },
	}
	local function geodesicSubDivide(p, frequency, offset)
		local p1 = p[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		local p2 = p[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		local p3 = p[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		local n = offset
		local c = {}
		local f = {} --           p3
		--           /\
		--          /__\     frequency = 3
		--      i  /\  /\
		--        /__\/__\       total triangles = 9 (frequency*frequency)
		--       /\  /\  /\
		--     0/__\/__\/__\
		--    p1 0   j      p2
		local function mix3(a, b, f)
			local _f = 1 - f
			local c = {}
			do
				local i = 0
				while
					i
					< 3 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
				do
					c[i] = a[i] * _f + b[i] * f
					i += 1
				end
			end
			return c
		end
		do
			local i = 0
			while
				i
				< frequency --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
			do
				do
					local j = 0
					while
						j
						< frequency - i --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
					do
						local t0 = i / frequency
						local t1 = (i + 1) / frequency
						local s0 = j / (frequency - i)
						local s1 = (j + 1) / (frequency - i)
						local s2 = if Boolean.toJSBoolean(frequency - i - 1) then j / (frequency - i - 1) else 1
						local q = {}
						q[
							1 --[[ ROBLOX adaptation: added 1 to array index ]]
						] =
							mix3(mix3(p1, p2, s0), p3, t0)
						q[
							2 --[[ ROBLOX adaptation: added 1 to array index ]]
						] =
							mix3(mix3(p1, p2, s1), p3, t0)
						q[
							3 --[[ ROBLOX adaptation: added 1 to array index ]]
						] =
							mix3(mix3(p1, p2, s2), p3, t1) -- -- normalize
						do
							local k = 0
							while
								k
								< 3 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
							do
								local r = vec3.length(q[k])
								do
									local l = 0
									while
										l
										< 3 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
									do
										q[k][l] /= r
										l += 1
									end
								end
								k += 1
							end
						end
						Array.concat(c, {
							q[
								1 --[[ ROBLOX adaptation: added 1 to array index ]]
							],
							q[
								2 --[[ ROBLOX adaptation: added 1 to array index ]]
							],
							q[
								3 --[[ ROBLOX adaptation: added 1 to array index ]]
							],
						}) --[[ ROBLOX CHECK: check if 'c' is an Array ]]
						table.insert(f, { n, n + 1, n + 2 }) --[[ ROBLOX CHECK: check if 'f' is an Array ]]
						n += 3
						if
							j
							< frequency - i - 1 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
						then
							local s3 = if Boolean.toJSBoolean(frequency - i - 1)
								then (j + 1) / (frequency - i - 1)
								else 1
							q[
								1 --[[ ROBLOX adaptation: added 1 to array index ]]
							] =
								mix3(mix3(p1, p2, s1), p3, t0)
							q[
								2 --[[ ROBLOX adaptation: added 1 to array index ]]
							] =
								mix3(mix3(p1, p2, s3), p3, t1)
							q[
								3 --[[ ROBLOX adaptation: added 1 to array index ]]
							] =
								mix3(mix3(p1, p2, s2), p3, t1) -- -- normalize
							do
								local k = 0
								while
									k
									< 3 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
								do
									local r = vec3.length(q[k])
									do
										local l = 0
										while
											l
											< 3 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
										do
											q[k][l] /= r
											l += 1
										end
									end
									k += 1
								end
							end
							Array.concat(c, {
								q[
									1 --[[ ROBLOX adaptation: added 1 to array index ]]
								],
								q[
									2 --[[ ROBLOX adaptation: added 1 to array index ]]
								],
								q[
									3 --[[ ROBLOX adaptation: added 1 to array index ]]
								],
							}) --[[ ROBLOX CHECK: check if 'c' is an Array ]]
							table.insert(f, { n, n + 1, n + 2 }) --[[ ROBLOX CHECK: check if 'f' is an Array ]]
							n += 3
						end
						j += 1
					end
				end
				i += 1
			end
		end
		return { points = c, triangles = f, offset = n }
	end
	local points = {}
	local faces = {}
	local offset = 0
	do
		local i = 0
		while
			i
			< #ti --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			local g = geodesicSubDivide({
				ci[
					tostring(ti[i][
						1 --[[ ROBLOX adaptation: added 1 to array index ]]
					])
				],
				ci[
					tostring(ti[i][
						2 --[[ ROBLOX adaptation: added 1 to array index ]]
					])
				],
				ci[
					tostring(ti[i][
						3 --[[ ROBLOX adaptation: added 1 to array index ]]
					])
				],
			}, frequency, offset)
			points = Array.concat(points, g.points) --[[ ROBLOX CHECK: check if 'points' is an Array ]]
			faces = Array.concat(faces, g.triangles) --[[ ROBLOX CHECK: check if 'faces' is an Array ]]
			offset = g.offset
			i += 1
		end
	end
	local geometry = polyhedron({ points = points, faces = faces, orientation = "inward" })
	if radius ~= 1 then
		geometry = geom3.transform(mat4.fromScaling(mat4.create(), { radius, radius, radius }), geometry)
	end
	return geometry
end
return geodesicSphere
