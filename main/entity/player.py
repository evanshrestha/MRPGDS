from entity.entity import Entity
import util.user_input as user_input
import util.asset_manager as asset_manager
import pygame

# the structure of this is mostly temporary - not sure how much you want to keep
class Player(Entity):
    def __init__(self, pos = (0, 0), size = (0, 0), screen = None):
        super().__init__(pos, size, screen)
        self.speed = 2
        self.speed_mult = 1

        # will be handled by some type of asset manager later,
        # images will probably some type of imagemap? (forgot the name of it)
        self.still_image = asset_manager.load_image("player_still.png")
        self.right_image = asset_manager.load_image("player_right.png")
        self.left_image = asset_manager.load_image("player_left.png")
        self.down_image = asset_manager.load_image("player_down.png")
        self.up_image = asset_manager.load_image("player_up.png")

        self.curr_image = self.still_image

    def render(self):
        # just a test - will probably change this to a surface instead of a white rectangle
        self.screen.render_image(self.pos[0], self.pos[1], self.size[0], self.size[1], self.curr_image)

    def update(self, delta):

        if user_input.action_map['sprint'].active():
            self.speed_mult = 3
        else:
            self.speed_mult = 1


        self.curr_image = self.still_image
        if user_input.action_map['up'].active():
            self.move(0, -(self.speed * self.speed_mult * delta / 20))
            self.curr_image = self.up_image
        if user_input.action_map['down'].active():
            self.move(0, (self.speed * self.speed_mult * delta / 20))
            self.curr_image = self.down_image
        if user_input.action_map['left'].active():
            self.move(-(self.speed * self.speed_mult * delta / 20), 0)
            self.curr_image = self.left_image
        if user_input.action_map['right'].active():
            self.move((self.speed * self.speed_mult * delta / 20), 0)
            self.curr_image = self.right_image


    def move(self, dx, dy):
        self.pos = (self.pos[0] + dx, self.pos[1] + dy)
