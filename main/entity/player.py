from entity.entity import Entity
import util.user_input as user_input
import pygame

class Player(Entity):
    def __init__(self, pos = (0, 0), size = (0, 0), screen = None):
        super().__init__(pos, size, screen)

    def render(self):
        # just a test - will probably change this to a surface instead of a white rectangle
        self.screen.render_rect(self.pos[0], self.pos[1], self.size[0], self.size[1], (255, 255, 255))

    def update(self):
        if user_input.keys['up']:
            self.move(0, -1)
        if user_input.keys['down']:
            self.move(0, 1)
        if user_input.keys['left']:
            self.move(-1, 0)
        if user_input.keys['right']:
            self.move(1, 0)

    def move(self, dx, dy):
        self.pos = (self.pos[0] + dx, self.pos[1] + dy)
