# level.py
# created 8/3/2018

import random
from graphics.tile.tile import Tile
from graphics.tile.tile import VOID_TILE

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
            self.tiles.append(Tile((
                                random.randint(0, 255),
                                random.randint(0, 255),
                                random.randint(0, 255))))

    def render(self, camera, screen):
        xs = int(camera.level_offset.x()) >> 4
        xe = int(camera.level_offset.x() + screen.get_width()) >> 4
        ys = int(camera.level_offset.y()) >> 4
        ye = int(camera.level_offset.y() + screen.get_height()) >> 4
        for y in range(ys, ye):
            for x in range(xs, xe):
                if x < 0 or y < 0 or x > self.width or y > self.height:
                    continue
                self.get_tile(x, y).render(x << 4, y << 4, screen)


    def update(self):
        pass

    def get_tile(self, x, y):
        if x + y * self.width >= len(self.tiles):
            return VOID_TILE
        return self.tiles[x + y * self.width]
