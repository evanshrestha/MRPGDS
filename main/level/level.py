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

    def render(self):
        pass

    def update(self):
        pass

    def get_tile(self, x, y):
        return tiles[x + y * self.width]
