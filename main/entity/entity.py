
'''
not sure how much you wanna abstract here
or how you wanna do this so change it
'''

# do we want to inherit from pygame's Sprite?
class Entity():

# probably should change this to whatever you wanna abstract
    def __init__(self, pos = (0, 0), size = (0, 0)):
        self.pos = pos
        self.size = size

    def render(self):
        pass

    def update(self, delta):
        pass

    def x(self):
        return self.pos[0]

    def y(self):
        return self.pos[1]

    def width(self):
        return self.size[0]

    def height(self):
        return self.size[1]
