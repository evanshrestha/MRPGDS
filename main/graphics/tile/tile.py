# tile.py
# created 8/3/2018

import random

class Tile(object):
    """docstring for Tile."""

    # global variables
    color = None
    size = None

    def __init__(self, color = (0,0,0)):
        # constructor
        self.color = color
        self.size = self.TILE_SIZE_32()

    def render(self, x, y, screen):
        screen.render_rect(x, y, self.size, self.size, self.color)

    def get_color(self):
        return self.color

    def TILE_SIZE_32(self):
        return 32

    # TODO get_bitshift function

VOID_TILE = Tile()
