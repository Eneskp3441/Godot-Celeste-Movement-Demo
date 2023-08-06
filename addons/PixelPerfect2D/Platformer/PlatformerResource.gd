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
@export var Wall_active:bool = true; 
@export var Wall_OnlyWhenMoving:bool = true; 
@export var Wall_Gravity:float = .1; 
@export var Wall_GravityMax:float = 1.75; 
@export var Wall_JumpHeight:float = 3.5; 
@export var Wall_JumpHeightMin:float = 3; 
@export var Wall_JumpOffset:float = 4; 
@export var Wall_JumpOffsetMin:float = 2; 
@export var Wall_JumpInputCooldown:float = .1; 
@export var Wall_SafeMargin:float = 2; 
@export var Wall_JumpBuffer:float = .1; 
@export_group("Feel")
# the time allowed to jump when falling from platforms.
@export var CoyotoTime:float = .15;
# when the character tries to jump while near the ground, the time it takes to jump when he reaches the ground
@export var JumpBuffer:float = .15;
