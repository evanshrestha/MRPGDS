
def __init__(self, game):
    self.game = game
    self.mapping = { "move_up": pygame.K_w,
                "move_down": pygame.K_s,
                "move_right": pygame.K_d,
                "move_left": pygame.K_a }

def handle_event(self, event):
    if event.type == pygame.QUIT:
        self.game.stop()
    if event.type == self.mapping["move_up"]:
        print("test")
