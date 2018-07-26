# screen.py
# created 7/26/2018

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
    display_surface = None # surface drawn directly to display
    raster = None # per pixel control

    # proabably needs surface
    def __init__(self, width, height):
        pass
