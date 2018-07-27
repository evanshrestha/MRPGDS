# game.py
# created 7/24/2018

'''
#desc
entry point for game...
'''

import sys
import pygame
from util import user_input
from util import util
from graphics.screen import Screen

class Game(object):

    #launch options
    # TODO: set up switch case stype dict for launch options

    #pre-defined variables
    display_flags = 0

    #global variables
    height = 600
    width = 800
    display = None
    screen = None

    clock = None
    tickrate = 20 #not-used
    framerate = 60 # 0 = unlimited
    running = False

    def __init__(self):
        #contructor
        pygame.init()
        self.clock = pygame.time.Clock()

        # import system arguments if this is the entry point of the game
        if __name__ == "__main__": self.handle_sys_args(sys.argv)

        self.display = pygame.display.set_mode((self.width, self.height), self.display_flags)
        self.screen = Screen(self.display)

        user_input.init(None)

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

    def handle_sys_args(self, args):
        args.pop(0) # remove the entry filename from args list
        if len(args) < 1: return

        for prev, arg, next in util.neighbors(args):
            #print(prev, arg, next)
            if arg == '-width' or arg == '-w':
                try: next = int(next)
                except Exception: continue
                else: self.width = next

            elif arg == '-height' or arg == '-h':
                try: next = int(next)
                except Exception: continue
                else: self.height = next

            # avoid using this, no way to exit fullscreen without closing
            # application also effects macOS other fullscreen applications
            # TODO: fully implement display control, possible display class
            elif arg == '-fullscreen':
                self.display_flags = self.display_flags | pygame.FULLSCREEN

game = Game()
game.start()
