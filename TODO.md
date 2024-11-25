## TODO

- [x] use jest-codemods on source to migrate from ava to jest syntax


- [x] convert source with js-to-lua


- [ ] correct wrong syntax
  - [x] arguments
  - [x] Array.new
  - [x] Array.spread
  - [x] Float32Array.new
  - [x] replace : syntax with . for vec2, vec3, vec4, mat4, plane, line2, poly2, poly3, geom2, geom3, path2, bezier, slice
  - [x] replace Array.length with #Array ( regex replace: ([\w\.]+)\.length\b with: #$1 )
  - [x] recreate js prototype classes with metatables
  - [x] add jest-lua requires to tests
  - [x] replace left over ava syntax
  - [x] replace incorrect jest js syntax with jest lua's
  - [x] replace json.stringify with lua-json.encode
  - [x] number:toString(radix)
  - [ ] boolean arithmetic
  - [ ] replace 0-based indexing


- [ ] confirm parity with unit tests
