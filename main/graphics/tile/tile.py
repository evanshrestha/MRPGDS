# tile.py
# created 8/3/2018

class Tile(object):
    """docstring for Tile."""

    # global variables
    color = None
    size = None

    def __init__(self):
        # constructor
        self.color = Color( random.randint(0, 256),
                            random.randint(0, 256),
                            random.randint(0, 256))
        self.size = TILE_SIZE_32()

    def get_color(self):
        return self.color

    def TILE_SIZE_32(self):
        return 32
