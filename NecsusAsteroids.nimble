# Package

version       = "0.1.0"
author        = "Nycto"
description   = "An implementation of Asteroids using Necsus"
license       = "Apache-2.0"
srcDir        = "src"
bin           = @["NecsusAsteroids"]


# Dependencies

requires "nim >= 1.6.2", "https://github.com/NecsusECS/Necsus", "sdl2", "bumpy", "vmath"
