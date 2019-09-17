# Package

version       = "0.1.0"
author        = "codestars"
description   = "Multiplayer RPG Dating Sim"
license       = "GPL-3.0-only"
srcDir        = "src"
binDir        = "bin"
bin           = @["mrpgds"]


# Dependencies

requires "nim >= 0.20.0"
requires "sdl2_nim", "opengl", "glm"
requires "https://github.com/60fov/nim-tiled.git"
