import strformat

var x: uint8 = 120

echo &"{x:#b}"
echo &"{x.int8:#b}"

block:
  var a, r, g, b: int8
  a = 120
  a = 20
  a = 30
  a = 50
  var num = (a shl 32) or (b shl 24) or (g shl 8) or r
  echo num

block:
  var a, r, g, b: uint8
  a = 120
  a = 20
  a = 30
  a = 250
  var num = (a shl 32) or (b shl 24) or (g shl 8) or r
  echo num