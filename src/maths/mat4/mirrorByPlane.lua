-- ROBLOX NOTE: no upstream
--[[*
 * Create a matrix for mirroring about the given plane.
 *
 * @param {mat4} out - receiving matrix
 * @param {vec4} plane - plane of which to mirror the matrix
 * @returns {mat4} out
 * @alias module:modeling/maths/mat4.mirrorByPlane
 ]]
local function mirrorByPlane(out, plane)
	local nx, ny, nz, w = table.unpack(plane, 1, 4)
	out[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 1.0 - 2.0 * nx * nx
	out[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = -2.0 * ny * nx
	out[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = -2.0 * nz * nx
	out[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 0
	out[
		5 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = -2.0 * nx * ny
	out[
		6 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 1.0 - 2.0 * ny * ny
	out[
		7 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = -2.0 * nz * ny
	out[
		8 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 0
	out[
		9 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = -2.0 * nx * nz
	out[
		10 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = -2.0 * ny * nz
	out[
		11 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 1.0 - 2.0 * nz * nz
	out[
		12 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 0
	out[
		13 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 2.0 * nx * w
	out[
		14 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 2.0 * ny * w
	out[
		15 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 2.0 * nz * w
	out[
		16 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 1
	return out
end
return mirrorByPlane
