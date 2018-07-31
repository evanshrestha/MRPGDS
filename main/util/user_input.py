# user_input
# created 7/25/2018

import pygame

# TODO should this be a class????



action_map = {
    'left': pygame.K_a,
    'right': pygame.K_d,
    'up': pygame.K_w,
    'down': pygame.K_s,
    'sprint': pygame.K_LSHIFT
} # user control mappings

active_keys = []

def init(args):
    for k in action_map:
        keys[k] = False

def poll():
    # TODO could use dictionary as switch???
    # handle all user input events
    for event in pygame.event.get():
        event_data = event.__dict__
        #print(event_data)

        if event.type == pygame.QUIT:
            exit()
        elif event.type == pygame.KEYDOWN:

        elif event.type == pygame.KEYUP: pass

        elif event.type == pygame.MOUSEBUTTONDOWN: pass
        elif event.type == pygame.MOUSEBUTTONUP: pass
        elif event.type == pygame.MOUSEMOTION: pass


class Key(object):
    """docstring for Key."""

    code = None
    is_active = False
    was_active = False

    def __init__(self, keycode):
        self.code = keycode

    def new_state(self, nstate):
        self.was_active = self.is_active
        self.is_active = nstate

    def active(self):
        return self.is_active

    # just these terribly written function
    def released(self):
        return (not self.is_active) and self.was_active

    def pressed(self):
        return self.is_active and (not self.was_active)
