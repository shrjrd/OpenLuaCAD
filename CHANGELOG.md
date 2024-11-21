## DONE

used jest-codemods to migrate from ava to jest syntax


convert source with js-to-lua


replaced 

require_()

with 

require()



replaced 

local expect = require("expect")

with

local JestGlobals = require("@DevPackages/JestGlobals")

local test, expect = JestGlobals.test, JestGlobals.expect


replaced 

module.exports =

with

return


regex replaced

([\w\.]+)\.length\b

with

#$1


replaced

local Packages = game.ReplicatedStorage.Packages

with

local Packages = game.ReplicatedStorage.Packages


replaced : syntax with . for vec2, vec3, vec4, mat4, plane, line2, poly2, poly3, geom2, geom3, path2, bezier, slice


replaced

    nearlyEqual(

	    t,

with

    nearlyEqual(


replaced

nearlyEqual(t,

with

nearlyEqual(


replaced 

javascript prototypes

with

metatables


replaced

Array.new(num)

with

table.create(num)


Error > Error.new


removed variable overshadowing


## TODO


correct 0-based indexing


parseInt


json.stringify


:substring to :sub


string:parseInt(radix)


number:toString(radix)


Boolean arithmitec

