# asset_manager
# created 7/29/2018

import pygame
import os

# rn this is just a shortcut, but if we add imagemaps (is that the word?)
# then we can change it to get a certain section of the loaded image
def load_image(image_path):
    return pygame.image.load(os.path.join("data", "../res/" + image_path))
