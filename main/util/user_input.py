# user_input
# created 7/25/2018

import pygame

# TODO should this be a class????


action_map = {'left': pygame.K_a,
        'right': pygame.K_d,
        'up': pygame.K_w,
        'down': pygame.K_s,
        'sprint': pygame.K_LSHIFT } # user control mappings

keys = {}

mods = None # bitmask of modifiers

# potential state system
'''
we could use the action_map to define which keys
will trigger a user event, and we could use
the user events to do things like open menus
move the character, etc

or

( im leaning towards this way )
create a list of keys (key being an object that
stores the key data such as keycode, state, etc)
and assign keys to the action_map and pass the
action_map to the player class

or

idk something logical/efficent/readable

'''

def init(args):
    for k in action_map:
        keys[k] = False
    # if not args:
    #     action_map = {
    #         'move_up'   : K_w,
    #         'move_down' : K_s,
    #         'move_left' : K_a,
    #         'move_right': K_d,
    #         'jump'      : K_SPACE
    #     }

def poll():
    # TODO could use dictionary as switch???
    # handle all user input events
    for event in pygame.event.get():
        event_data = event.__dict__
        #print(event_data)

        if event.type == pygame.QUIT:
            exit()
        elif event.type == pygame.KEYDOWN: pass
        elif event.type == pygame.KEYUP: pass
        elif event.type == pygame.MOUSEBUTTONDOWN: pass
        elif event.type == pygame.MOUSEBUTTONUP: pass
        elif event.type == pygame.MOUSEMOTION: pass

    for k in keys:
        keys[k] = pygame.key.get_pressed()[action_map[k]]
