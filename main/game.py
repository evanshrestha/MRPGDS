# game.py
# created 7/24/2018

'''
#desc
entry point for game...
'''

import pygame
from util import user_input

class Game(object):

    #pre-defined variables
    display_flags = None
    system_args = None

    #global variables
    clock = None
    display = None
    tickrate = 20 #not-used
    framerate = 60 # 0 = unlimited
    running = False

    def __init__(self):
        #contructor
        pygame.init()
        self.clock = pygame.time.Clock()
        self.display = pygame.display.set_mode((800,600))

        user_input.init(pygame, None)

    def update(self, delta):
        # entry point for all loop logic
        # print(delta)
        user_input.poll()

    def render(self):
        # entry point for all graphics
        self.display.fill((0,0,0))
        pygame.display.flip()

    def run(self):
        # mainloop
        while self.running:
            self.update(self.clock.get_time())

            # render method ran based on clock
            self.render()
            self.clock.tick(self.framerate)

    def start(self):
        self.running = True
        self.run()

    def stop(self):
        self.running = False

# import system arguments if this is the entry point of the game
if __name__ == "__main__":
    import sys
    system_args = sys.argv

game = Game()
game.start()
