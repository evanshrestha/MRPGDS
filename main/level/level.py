# level.py
# created 8/3/2018

from graphics.tile.tile import Tile

class Level(object):
    """docstring for Level."""
    # global variables
    width = None
    height = None
    tiles = []

    def __init__(self, width, height):
        # constructor
        self.width = width
        self.height = height
        self.generate()

    def generate(self):
        for n in range(self.width * self.height):
            self.tiles.append(Tile())

    def render(self, camera, screen):
        xs = camera.levelOffsetX() >> 4;
		xe = camera.levelOffsetX() + screen.width() >> 4;
		ys = camera.levelOffsetY() >> 4;
		ye = camera.levelOffsetY() + screen.height() >> 4;
        for y in range(ys,ye):
            for x in range(xs,xe):
                get_tile(x, y).render(x << 4, y << 4, screen)


    def update(self):
        pass

    def get_tile(self, x, y):
        return tiles[x + y * self.width]
