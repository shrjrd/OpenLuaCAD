-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
-- Simon Tatham's linked list merge sort algorithm
-- https://www.chiark.greenend.org.uk/~sgtatham/algorithms/listsort.html
local function sortLinked(list, fn)
	local i, p, q, e, numMerges
	local inSize = 1
	repeat
		p = list
		list = nil
		local tail = nil
		numMerges = 0
		while Boolean.toJSBoolean(p) do
			numMerges += 1
			q = p
			local pSize = 0
			i = 0
			while
				i
				< inSize --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
			do
				pSize += 1
				q = q.nextZ
				if not Boolean.toJSBoolean(q) then
					break
				end
				i += 1
			end
			local qSize = inSize
			while
				Boolean.toJSBoolean(
					pSize > 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
						or qSize > 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
							and q
				)
			do
				if
					pSize ~= 0
					and (
						qSize == 0
						or not Boolean.toJSBoolean(q)
						or fn(p) <= fn(q) --[[ ROBLOX CHECK: operator '<=' works only if either both arguments are strings or both are a number ]]
					)
				then
					e = p
					p = p.nextZ
					pSize -= 1
				else
					e = q
					q = q.nextZ
					qSize -= 1
				end
				if Boolean.toJSBoolean(tail) then
					tail.nextZ = e
				else
					list = e
				end
				e.prevZ = tail
				tail = e
			end
			p = q
		end
		tail.nextZ = nil
		inSize *= 2
	until not (
			numMerges
			> 1 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		)
	return list
end
return sortLinked
