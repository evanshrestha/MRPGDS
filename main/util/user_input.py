# user_input
# created 7/25/2018

# TODO should this be a class????


action_map = None # user control mappings
keys = [] # list of keys (index = keycode)
mods = None # bitmask of modifiers
game_lib = None # pygame lib


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

def init(pygame_lib, args):
    global game_lib
    game_lib = pygame_lib
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
    for event in game_lib.event.get():

        event_data = event.__dict__
        #print(event_data)

        if event.type == game_lib.QUIT:
            exit()
        elif event.type == game_lib.KEYDOWN: pass
        elif event.type == game_lib.KEYUP: pass
        elif event.type == game_lib.MOUSEBUTTONDOWN: pass
        elif event.type == game_lib.MOUSEBUTTONUP: pass
        elif event.type == game_lib.MOUSEMOTION: pass
