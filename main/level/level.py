# level.py
# created 8/3/2018

import random
from graphics.tile.tile import Tile
from graphics.tile.tile import VOID_TILE
import math

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
        n = 0
        for i in range(self.width * self.height):
            self.tiles.append(Tile((n,100,200)))
            n+=1
            print(n)
            if n>255:
                n=0
            #self.tiles.append(Tile((
                                #random.randint(0, 255),
                                #random.randint(0, 255),
                                #random.randint(0, 255))))

    def render(self, camera, screen):
        xs = 0
        xe = int((screen.get_width() + 32) / 32)
        ys = 0
        ye = int((screen.get_height() + 32) / 32)

        print(camera.level_offset.x(), camera.level_offset.y())

        for y in range(ys, ye):
            for x in range(xs, xe):
                if x < 0 or y < 0 or x > self.width or y > self.height:
                    continue
                self.get_tile(x, y).render(round(camera.level_offset.x()) + (x * 32), round(camera.level_offset.y()) + (y * 32), screen)


    def update(self):
        pass

    def get_tile(self, x, y):
        if x + y * self.width >= len(self.tiles):
            return VOID_TILE
        return self.tiles[x + y * self.width]
