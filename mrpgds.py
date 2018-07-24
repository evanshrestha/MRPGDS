# mrpgds.py

import pygame


pygame.init()
screen = pygame.display.set_mode((800, 600))
icon = pygame.image.load('res/heart favicon 256.png')
pygame.display.set_icon(icon)
is_blue = True

clock = pygame.time.Clock()


class Player(object):
    def __init__(self):
        self.x = 30
        self.y = 30
        self.x_vel = 0
        self.y_vel = 0
        self.sprint = False
        self.init_speed = 3
        self.sprint_speed = 6
        self.speed = self.init_speed
        self.orientation = "UP"

player = Player()

def handle_key_events(pressed):
    global is_blue
    global player
    global clock


    # Key event listener
    if pressed[pygame.K_UP] or pressed[pygame.K_w]:
        player.y_vel = -player.speed
        player.orientation = "UP"
    if pressed[pygame.K_DOWN] or pressed[pygame.K_s]:
        player.y_vel = player.speed
        player.orientation = "DOWN"
    if pressed[pygame.K_LEFT] or pressed[pygame.K_a]:
        player.x_vel = -player.speed
        player.orientation = "LEFT"
    if pressed[pygame.K_RIGHT] or pressed[pygame.K_d]:
        player.x_vel = player.speed
        player.orientation = "RIGHT"

    if pressed[pygame.K_LSHIFT]:
        player.sprint = True
    else:
        player.sprint = False

def main():

    done = False

    global is_blue
    global player
    global clock

    while not done:
            for event in pygame.event.get():
                    if event.type == pygame.QUIT:
                            done = True
                    if event.type == pygame.KEYDOWN and event.key == pygame.K_SPACE:
                            is_blue = not is_blue

            handle_key_events(pygame.key.get_pressed())

            if player.sprint:
                player.speed = player.sprint_speed
            else:
                player.speed = player.init_speed

            # Move player
            player.y += player.y_vel
            player.x += player.x_vel

            # Dampen movement
            player.y_vel /= 1.2
            player.x_vel /= 1.2

            # Draw to screen
            screen.fill((0,0,0))
            if is_blue: color = (0, 128, 255)
            else: color = (255, 100, 0)
            pygame.draw.rect(screen, color, pygame.Rect(player.x, player.y, 60, 60))

            pygame.display.flip()
            clock.tick(120)

main()
