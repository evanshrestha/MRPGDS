# point.py
# created 8/5/2018

class Point(object):
    """docstring for point."""

    #global variables
    xp = None
    yp = None

    def __init__(self, x = 0, y = 0):
        # constructor
        self.xp = x
        self.yp = y

    def x(self, *args):
        if args:
            self.xp += args[0]
        return self.xp

    def y(self, *args):
        if args:
            self.yp += args[0]
        return self.yp
