-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local comparePoints = require("../../../test/helpers").comparePoints
local geom2 = require("../../geometries").geom2
local circle, rectangle
do
	local ref = require("../../primitives")
	circle, rectangle = ref.circle, ref.rectangle
end
local union = require("./init").union
local center = require("../transforms/center").center
local translate = require("../transforms/translate").translate
test("union of one or more geom2 objects produces expected geometry", function()
	local geometry1 = circle({ radius = 2, segments = 8 }) -- union of one object
	local result1 = union(geometry1)
	local obs = geom2.toPoints(result1)
	local exp = {
		{ 2, 0 },
		{ 1.4142000000000001, 1.4142000000000001 },
		{ 0, 2 },
		{ -1.4142000000000001, 1.4142000000000001 },
		{ -2, 0 },
		{ -1.4142000000000001, -1.4142000000000001 },
		{ 0, -2 },
		{ 1.4142000000000001, -1.4142000000000001 },
	}
	expect(function()
		return geom2.validate(result1)
	end)["not"].toThrow()
	expect(comparePoints(obs, exp)).toBe(true) -- union of two non-overlapping objects
	local geometry2 = center({ relativeTo = { 10, 10, 0 } }, rectangle({ size = { 4, 4 } }))
	local result2 = union(geometry1, geometry2)
	obs = geom2.toPoints(result2)
	exp = {
		{ 2, 0 },
		{ 1.4142000000000001, 1.4142000000000001 },
		{ 0, 2 },
		{ -1.4142000000000001, 1.4142000000000001 },
		{ -2, 0 },
		{ -1.4142000000000001, -1.4142000000000001 },
		{ 0, -2 },
		{ 8, 12 },
		{ 8, 8 },
		{ 12, 8 },
		{ 12, 12 },
		{ 1.4142000000000001, -1.4142000000000001 },
	}
	expect(function()
		return geom2.validate(result2)
	end)["not"].toThrow()
	expect(comparePoints(obs, exp)).toBe(true) -- union of two partially overlapping objects
	local geometry3 = rectangle({ size = { 18, 18 } })
	local result3 = union(geometry2, geometry3)
	obs = geom2.toPoints(result3)
	exp = {
		{ 11.999973333333333, 11.999973333333333 },
		{ 7.999933333333333, 11.999973333333333 },
		{ 9.000053333333334, 7.999933333333333 },
		{ -9.000053333333334, 9.000053333333334 },
		{ -9.000053333333334, -9.000053333333334 },
		{ 9.000053333333334, -9.000053333333334 },
		{ 7.999933333333333, 9.000053333333334 },
		{ 11.999973333333333, 7.999933333333333 },
	}
	expect(function()
		return geom2.validate(result3)
	end)["not"].toThrow()
	expect(comparePoints(obs, exp)).toBe(true) -- union of two completely overlapping objects
	local result4 = union(geometry1, geometry3)
	obs = geom2.toPoints(result4)
	exp = {
		{ -9.000046666666666, -9.000046666666666 },
		{ 9.000046666666666, -9.000046666666666 },
		{ 9.000046666666666, 9.000046666666666 },
		{ -9.000046666666666, 9.000046666666666 },
	}
	expect(function()
		return geom2.validate(result4)
	end)["not"].toThrow()
	expect(comparePoints(obs, exp)).toBe(true) -- union of unions of non-overlapping objects (BSP gap from #907)
	local circ = circle({ radius = 1, segments = 32 })
	local result5 = union(
		union(translate({ 17, 21 }, circ), translate({ 7, 0 }, circ)),
		union(translate({ 3, 21 }, circ), translate({ 17, 21 }, circ))
	)
	obs = geom2.toPoints(result5)
	t.notThrows:skip(function()
		return geom2.validate(result5)
	end)
	expect(#obs).toBe(112)
end)
test("union of geom2 with closing issues #15", function()
	local c = geom2.create({
		{
			{ -45.82118740347841168159, -16.85726810555620147625 },
			{ -49.30331715865012398581, -14.68093629710870118288 },
		},
		{
			{ -49.10586702080816223770, -15.27604177352110781385 },
			{ -48.16645938811709015681, -15.86317173589183227023 },
		},
		{
			{ -49.60419521731581937729, -14.89550781504266296906 },
			{ -49.42407001323204696064, -15.67605088949303393520 },
		},
		{
			{ -49.05727291218684626983, -15.48661638542171203881 },
			{ -49.10586702080816223770, -15.27604177352110781385 },
		},
		{
			{ -49.30706235399220815907, -15.81529674600091794900 },
			{ -46.00505780290426827150, -17.21108547999804727624 },
		},
		{
			{ -46.00505780290426827150, -17.21108547999804727624 },
			{ -45.85939703723252591772, -17.21502856394236857795 },
		},
		{
			{ -45.85939703723252591772, -17.21502856394236857795 },
			{ -45.74972032664388166268, -17.11909303495791334626 },
		},
		{
			{ -45.74972032664388166268, -17.11909303495791334626 },
			{ -45.73424573227583067592, -16.97420292661295349035 },
		},
		{
			{ -45.73424573227583067592, -16.97420292661295349035 },
			{ -45.82118740347841168159, -16.85726810555620147625 },
		},
		{
			{ -49.30331715865012398581, -14.68093629710870118288 },
			{ -49.45428884427643367871, -14.65565769658912387285 },
		},
		{
			{ -49.45428884427643367871, -14.65565769658912387285 },
			{ -49.57891661679624917269, -14.74453612941635327616 },
		},
		{
			{ -49.57891661679624917269, -14.74453612941635327616 },
			{ -49.60419521731581937729, -14.89550781504266296906 },
		},
		{
			{ -49.42407001323204696064, -15.67605088949303393520 },
			{ -49.30706235399220815907, -15.81529674600091794900 },
		},
		{
			{ -48.16645938811709015681, -15.86317173589183227023 },
			{ -49.05727291218684626983, -15.48661638542171203881 },
		},
	})
	local d = geom2.create({
		{
			{ -49.03431352173912216585, -15.58610714407888764299 },
			{ -49.21443872582289458251, -14.80556406962851667686 },
		},
		{
			{ -68.31614651314507113966, -3.10790373951434872879 },
			{ -49.34036769611472550423, -15.79733157434056778357 },
		},
		{
			{ -49.58572929483430868913, -14.97552686612213790340 },
			{ -49.53755741140093959984, -15.18427183431472826669 },
		},
		{
			{ -49.53755741140093959984, -15.18427183431472826669 },
			{ -54.61235529924312714911, -11.79066769321313756791 },
		},
		{
			{ -49.30227466841120076424, -14.68159232649114187552 },
			{ -68.09792828135776687759, -2.77270756611528668145 },
		},
		{
			{ -49.21443872582289458251, -14.80556406962851667686 },
			{ -49.30227466841120076424, -14.68159232649114187552 },
		},
		{
			{ -49.34036769611472550423, -15.79733157434056778357 },
			{ -49.18823337756091262918, -15.82684012194931710837 },
		},
		{
			{ -49.18823337756091262918, -15.82684012194931710837 },
			{ -49.06069007212390431505, -15.73881563386780157998 },
		},
		{
			{ -49.06069007212390431505, -15.73881563386780157998 },
			{ -49.03431352173912216585, -15.58610714407888764299 },
		},
		{
			{ -68.09792828135776687759, -2.77270756611528668145 },
			{ -68.24753735887460948106, -2.74623350179570024920 },
		},
		{
			{ -68.24753735887460948106, -2.74623350179570024920 },
			{ -68.37258141465594007968, -2.83253376987636329432 },
		},
		{
			{ -68.37258141465594007968, -2.83253376987636329432 },
			{ -68.40089829889257089235, -2.98180502037078554167 },
		},
		{
			{ -68.40089829889257089235, -2.98180502037078554167 },
			{ -68.31614651314507113966, -3.10790373951434872879 },
		},
		{
			{ -54.61235529924312714911, -11.79066769321313756791 },
			{ -49.58572929483430868913, -14.97552686612213790340 },
		},
	}) -- geom2.toOutlines(c)
	-- geom2.toOutlines(d)
	local obs = union(c, d) -- const outlines = geom2.toOutlines(obs)
	local pts = geom2.toPoints(obs)
	local exp = {
		{ -49.10585516965137, -15.276000175919414 },
		{ -49.0573272145917, -15.486679335654257 },
		{ -49.307011370463215, -15.815286644243773 },
		{ -46.00502320253235, -17.211117609669667 },
		{ -45.85943933735334, -17.215031154432545 },
		{ -45.74972963250071, -17.119149307742074 },
		{ -45.734205904941305, -16.974217700023555 },
		{ -48.166473975068946, -15.86316234184296 },
		{ -49.318621553259746, -15.801589237573706 },
		{ -49.585786209072104, -14.975570389622606 },
		{ -68.31614189569036, -3.1078763476921982 },
		{ -49.53751915699663, -15.184292776976012 },
		{ -68.09789654941396, -2.7727464644978874 },
		{ -68.24752441084793, -2.7462648116024244 },
		{ -68.37262739176788, -2.8324932478777995 },
		{ -68.40093536555268, -2.98186020632758 },
		{ -54.61234310251047, -11.79072766159384 },
		{ -49.30335872868453, -14.680880468978017 },
		{ -49.34040695243976, -15.797284338334542 },
		{ -45.82121705016925, -16.857333163105647 },
	}
	expect(function()
		return geom2.validate(obs)
	end)["not"].toThrow()
	expect(#pts).toBe(20) -- number of sides in union
	expect(comparePoints(pts, exp)).toBe(true)
end)