# camera.py
# created 8/3/2018

from util.maths.point import Point

class Camera(object):
    """docstring for Camera."""

    # global variables
    level_offset = Point()
    player_position = Point()
    player_offset = Point()

    def __init__(self):
        # constructor
        level_offset = Point()
        player_position = Point()
        player_offset = Point()

    def update(self, player, level, screen):
        self.level_offset.x( player.x() - (screen.get_width() - player.width()) / 2 - self.player_offset.x() )
        self.level_offset.y( player.y() - (screen.get_height() - player.height()) / 2 - self.player_offset.y() )
        self.player_position.x( (screen.get_width() - player.width()) / 2 + self.player_offset.x() )
        self.player_position.y( (screen.get_height() - player.height()) / 2 + self.player_offset.y() )
