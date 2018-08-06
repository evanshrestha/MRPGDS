# point.py
# created 8/5/2018

class Point(object):
    """docstring for point."""

    #global variables
    x = None
    y = None

    def __init__(self, x = 0, y = 0):
        # constructor
        self.x = x
        self.y = y

    def x(self, *args):
        if args:
            self.x += args[0]
        return self.x

    def y(self, *args):
        if args:
            self.y += args[0]
        return self.y
