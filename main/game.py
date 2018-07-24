# game.py
# created 7/24/2018

'''
#desc
entry point for game...
'''

import pygame

# @evan hit me up I have a question about defining variables then instaintiating them

#pre-defined variables
clock = pygame.time.Clock()

#global variables
tickrate = 20
framerate = 60 # 0 = unlimited
running = 1

def init():
    #pseudo-contructor
    pygame.init()

def update(delta): pass
    # entry point for all loop logic

def render(): pass
    # entry point for all graphics

def main():

    init()


    # mainloop
    while running:
        # TODO choose update method
        '''
        current:
            time passed since last update call [delta time] and
            use it as a modifier for movement, etc
        alternative:
            limit the rate in which the update function is called
            e.g. call the method every X milliseconds

        both have inaccuracy due to the clock object limitations,
        however not sure which would be more accurate / efficent
        '''
        update(clock.get_time())

        # render method ran based on clock
        render()
        clock.tick(framerate)

main()
