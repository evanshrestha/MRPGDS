# user_input
# created 7/25/2018

import pygame

# TODO should this be a class????

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



keys = {
    pygame.K_a: 'left',
    pygame.K_d: 'right',
    pygame.K_w: 'up',
    pygame.K_s: 'down',
    pygame.K_LSHIFT: 'sprint'
}

action_map = {
    'left': Key(pygame.K_a),
    'right': Key(pygame.K_d),
    'up': Key(pygame.K_w),
    'down': Key(pygame.K_s),
    'sprint': Key(pygame.K_LSHIFT)
} # user control mappings

active_keys = []

def init(args):
    for k in action_map:
        action_map[k].new_state(False)

def poll():
    # TODO could use dictionary as switch???
    # handle all user input events
    for key in active_keys:
        action_map[keys[key]].was_active = action_map[keys[key]].is_active
        if action_map[keys[key]].released():
            action_map[keys[key]].was_active = False
            active_keys.remove(key)



    for event in pygame.event.get():
        event_data = event.__dict__
        #print(event_data)

        if event.type == pygame.QUIT:
            exit()
        elif event.type == pygame.KEYDOWN:
            action_map[keys[event.key]].new_state(True)
            active_keys.append(event.key)
        elif event.type == pygame.KEYUP:
            action_map[keys[event.key]].new_state(False)
        elif event.type == pygame.MOUSEBUTTONDOWN: pass
        elif event.type == pygame.MOUSEBUTTONUP: pass
        elif event.type == pygame.MOUSEMOTION: pass
