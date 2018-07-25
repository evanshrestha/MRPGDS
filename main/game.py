# game.py
# created 7/24/2018

'''
#desc
entry point for game...
'''

import pygame

# @evan hit me up I have a question about defining variables then instaintiating them

#pre-defined variables
clock = None

#global variables
tickrate = 20
framerate = 60 # 0 = unlimited
running = False

def init():
    #pseudo-contructor
    pygame.init()
    clock = pygame.time.Clock()

def update(delta): pass
    # entry point for all loop logic

def render(): pass
    # entry point for all graphics

def main():

    init()

    # mainloop
    while running:
        update(clock.get_time())

        # render method ran based on clock
        render()
        clock.tick(framerate)

main()
