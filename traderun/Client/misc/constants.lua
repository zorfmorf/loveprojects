DEVELOPER_MODE = true
DRAW_QUADTREE = false

LAYER_SIZE = 1 -- the amount of space layers
LAYER_SHIP = 1 -- the layer of the ship
SHIP_MAXSPEED = 20000 -- maxspeed for ships
SHIP_SIDETHRUSTER_CD = 0.1 -- time it takes until sidethrusters can be activated again
OBJECT_DECELERATION_FACTOR = 0.005 -- both for velocity and rotation
SHIP_COLLISION_FACTOR = 0.2 -- the higher the earlier collisions are resolved. 0 to 0.5
COLLISION_THRESHOLD = 0.7 -- the factor by which objects can move "into" each others bounds before collision. 1 => collision happens before visual collision. 0 => never collisions
PLAYER_COLLISION_THRESHOLD = 0.3 -- "softness" of the values. 0 is softest, 0.5 means you cant get near a wall
PLAYER_COLLISION_SLOW = 0.6 -- the value by which movement speed is decreased when colliding with wall
CAMERA_SWITCH_TIME = 1 -- the time needed for the camera to switch views
CAMERA_PLAYER_MOVING_SCALE = 1.5
CAMERA_PLAYER_COMMANDING_SCALE = 1
SCALE_MAX = 2
SCALE_MIN = 0.5

-- graphical constants
TILE_SIZE = 64 -- size of individual ship parts
TILE_SIZE_CHAR = 16 -- size of player


-- traderun constants
CHALLENGE_STATE_INACTIVE = "inactive"
CHALLENGE_STATE_ACTIVE = "active"
CHALLENGE_STATE_FINISHED = "finished"

CHALLENGE_ASTEROID_DELAY = 8
CHALLENGE_ASTEROID_DURATION = 7

-- lifeform constants
HUMAN_SPEED_FORWARD = 0.5 -- walking speed per second
HUMAN_SPEED_BACKWARD = -0.25 
HUMAN_STRAFE_SPEED = 0.35 


-- now load the default keybindings
KEY_DRAW_QUADTREE = "f2"
KEY_DEVELOPER_MODE = "f1"
KEY_EXIT = "escape"
KEY_SWITCH_COMMAND = " " -- leave/enter command mode

-- keys when commanding ship
KEY_C_ZOOM_IN = "i"
KEY_C_ZOOM_OUT = "k"
KEY_C_ROT_LEFT = "q"
KEY_C_ROT_RIGHT = "e"
KEY_C_UP = "up"
KEY_C_RIGHT = "right"
KEY_C_DOWN = "down"
KEY_C_LEFT = "left"
KEY_C_PAUSE = "p"
KEY_C_TARGET_DELETE = "x"

-- keys when moving around ship
KEY_M_USE = "e" -- interact with object
KEY_M_FORWARD = "w" -- move up
KEY_M_BACKWARD = "s" -- move down
KEY_M_STRAFE_LEFT = "a" -- move left
KEY_M_STRAFE_RIGHT = "d" -- move right
