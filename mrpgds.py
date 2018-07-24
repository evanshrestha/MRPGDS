# mrpgds.py

import pygame


pygame.init()
screen = pygame.display.set_mode((800, 600))
icon = pygame.image.load('res/heart favicon.png')
pygame.display.set_icon(icon)
is_blue = True
x = 30
y = 30

x_vel = 0
y_vel = 0

sprint = False

init_speed = 3
sprint_speed = 6

speed = init_speed

orientation = "UP"

clock = pygame.time.Clock()

def handle_key_events(pressed):
    global is_blue
    global x
    global y
    global x_vel
    global y_vel
    global sprint
    global init_speed
    global sprint_speed
    global speed
    global orientation
    global clock


    # Key event listener
    if pressed[pygame.K_UP] or pressed[pygame.K_w]:
        y_vel = -speed
        orientation = "UP"
    if pressed[pygame.K_DOWN] or pressed[pygame.K_s]:
        y_vel = speed
        orientation = "DOWN"
    if pressed[pygame.K_LEFT] or pressed[pygame.K_a]:
        x_vel = -speed
        orientation = "LEFT"
    if pressed[pygame.K_RIGHT] or pressed[pygame.K_d]:
        x_vel = speed
        orientation = "RIGHT"

    if pressed[pygame.K_LSHIFT]:
        sprint = True
    else:
        sprint = False

def main():

    done = False

    global is_blue
    global x
    global y
    global x_vel
    global y_vel
    global sprint
    global init_speed
    global sprint_speed
    global speed
    global orientation
    global clock

    while not done:
            for event in pygame.event.get():
                    if event.type == pygame.QUIT:
                            done = True
                    if event.type == pygame.KEYDOWN and event.key == pygame.K_SPACE:
                            is_blue = not is_blue

            handle_key_events(pygame.key.get_pressed())

            if sprint:
                speed = sprint_speed
            else:
                speed = init_speed

            # Move player
            y += y_vel
            x += x_vel

            # Dampen movement
            y_vel /= 1.2
            x_vel /= 1.2

            # Draw to screen
            screen.fill((0,0,0))
            if is_blue: color = (0, 128, 255)
            else: color = (255, 100, 0)
            pygame.draw.rect(screen, color, pygame.Rect(x, y, 60, 60))

            pygame.display.flip()
            clock.tick(120)

main()
