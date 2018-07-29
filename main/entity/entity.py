
'''
not sure how much you wanna abstract here
or how you wanna do this so change it
'''

class Entity():

# probably should change this to whatever you wanna abstract
    def __init__(self, pos = (0, 0), size = (0, 0), screen = None):
        self.pos = pos
        self.size = size
        self.screen = screen

    def render(self):
        pass

    def update(self, delta):
        pass
