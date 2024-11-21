--[[
return {
	testMatch = {
		"**/__tests__/*.(spec|test)",
	},
	testPathIgnorePatterns = {
		"Packages",
		"DevPackages",
	},
}
]]

return {
	testMatch = { "**/*.spec" },
	testPathIgnorePatterns = {
		"Packages",
		"DevPackages",
	},
}
