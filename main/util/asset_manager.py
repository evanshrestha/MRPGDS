# asset_manager
# created 7/29/2018

import pygame
import os

# rn this is just a shortcut, but if we add imagemaps (is that the word?)
# then we can change it to get a certain section of the loaded image
def load_image(image_path):
    path_prefix = ""
    if os.name == "nt":
        path_prefix = "data"
    return pygame.image.load(os.path.join(path_prefix, "../res/" + image_path))
