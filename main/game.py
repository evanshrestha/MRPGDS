# game.py
# created 7/24/2018

'''
#desc
entry point for game...
'''

import pygame

class Game(object):

    #pre-defined variables
    clock = pygame.time.Clock()

    display = pygame.display.set_mode((800,600))

    #global variables
    tickrate = 20
    framerate = 60 # 0 = unlimited
    running = True

    def __init__(self):
        #contructor
        pygame.init()
        self.clock = pygame.time.Clock()

    def update(self, delta):
        print(delta)
        # entry point for all loop logic
        # for event in pygame.event.get():
        #     if event
        #     # keyboard.handle_event(event, pygame, self)

    def render(self):
        # entry point for all graphics
        self.display.fill((0,0,0))
        pygame.display.flip()

    def stop(self):
        self.running = False

    def main(self):
        while self.running:
            self.update(self.clock.get_time())
            self.render()
            self.clock.tick(self.framerate)


game = Game()
game.main()
