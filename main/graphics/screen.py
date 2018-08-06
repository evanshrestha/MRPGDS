# screen.py
# created 7/26/2018

import pygame
import pygame.sprite

'''
#desc
this class is used for abstracting (correct word?)
the "drawing" code for easy of use and control
'''

class Screen(object):
    """docstring for Screen."""

    # TODO: decide and implement structure

    # TODO: test main surface for reference

    # global variables
    width = None
    height = None
    surface = None # surface drawn directly to display
    raster = None # per pixel control

    # proabably needs surface
    def __init__(self, surf):
        self.surface = surf
        self.width, self.height = surf.get_size()

    # TODO
    # not sure if this is how we want this to be done
    # since right now we aren't actually using pygame's sprites (can change),
    # I'm changing this to just render an image
    def render_image(self, x, y, width, height, img):
        self.surface.blit(pygame.transform.scale(img, (width, height)), (x, y))

    def render_sprite(self, sprite): pass

    def render_rect(self, x, y, width, height, color):
        rect_surf = pygame.Surface((width, height))
        rect_surf.fill(color)
        self.surface.blit(rect_surf, (x, y))

    def width(self):
        return self.width

    def height(self):
        return self.height
