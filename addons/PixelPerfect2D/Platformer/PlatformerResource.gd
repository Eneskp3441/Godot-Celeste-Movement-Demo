class_name PlatformerResource extends Resource
#################################
#||                            ||
#||      Export Variables      ||
#||                            ||
#################################

@export_category("Main Variables")
## Character Speed
@export var Speed:float = 2.;
## Character acceleration curve 
@export var Acceleration = .28;
## Character friction curve 
@export var Friction = .337;
## acceleration value when the character goes in the opposite direction
@export var TurnSpeed:float = .56;

@export_category("Platformer Variables")
@export_group("Gravity Variables")
## the force the character will exert towards the ground
@export var Gravity:float = .3;
## multiplier of the force exerted by the character on the ground
@export var DownGravity:float = 1;
## multiplier of the force exerted by the character on the ground
@export var UpGravity:float = .8;
## Maximum the maximum force the character will exert on the ground
@export var GravityMaximum:float = 4.75;
# GravityScale
@export var GravityScale:float = 1.;
@export_group("On Air Variables")
## acceleration value in air
@export var AirAcceleration:float = 0.2;
## control value in air
@export var AirControl:float = .85;
## friction value in air
@export var AirBrake:float = .25;
@export_group("Jumping")
## how high the character jumps
@export var JumpHeight:float = 4.5;
# how much the jump will decrease in divide when the key is released.
@export var JumpCutoff:float = 2;
@export_group("Wall Jump", "Wall_")
## whether wall jump will be active
@export var Wall_active:bool = true; 
## To make a slide on the wall, the character must walk towards the wall.
@export var Wall_OnlyWhenMoving:bool = true; 
## the gravity of the wall slide
@export var Wall_Gravity:float = .1; 
## maximum gravity when doing a wall slide
@export var Wall_GravityMax:float = 1.75; 
## wall jump height
@export var Wall_JumpHeight:float = 3.5; 
## small wall jump jump value
@export var Wall_JumpHeightMin:float = 3; 
## how much to push the character during wall jumpo
@export var Wall_JumpOffset:float = 4; 
## character push value on small wall jumps
@export var Wall_JumpOffsetMin:float = 2; 
## How long (seconds) inputs will be deactive on wall jumps
@export var Wall_JumpInputCooldown:float = .1; 
## how many pixels away to control the walls for wall jump
@export var Wall_SafeMargin:float = 2; 
## record the jump for the key pressed a few seconds before
@export var Wall_JumpBuffer:float = .1; 
@export_group("Feel")
## the time allowed to jump when falling from platforms.
@export var CoyotoTime:float = .15;
## when the character tries to jump while near the ground, the time it takes to jump when he reaches the ground
@export var JumpBuffer:float = .15;
## How far should you check to see if you are in the corner? The value should be adjusted according to the collision width.
@export var EdgeCheckDistance:float = 8;
## pushing the character around the corner when the character's head hits the corner.
@export var CornerCorrectionSize:float = 3;
