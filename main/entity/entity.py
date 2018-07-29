from graphics.screen import Screen

class Entity():

'''
not sure how much you wanna abstract here
or how you wanna do this so change it
'''

# probably should change this to whatever you wanna abstract
    def __init__(self, pos = (0, 0), size = (0, 0)):
        self.pos = pos
        self.size = size

    def render(self):
        pass

    def update(self):
        pass
    
