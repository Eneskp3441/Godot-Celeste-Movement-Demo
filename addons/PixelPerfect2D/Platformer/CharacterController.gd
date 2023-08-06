class_name CharacterController2D extends CharacterBody2D



#################################
#||                            ||
#||     Default Variables      ||
#||                            ||
#################################

@export var CharacterMovement:PlatformerResource;

## The character's velocity value. This value works in accordance with acceleration and friction.
var CharacterVelocity:Vector2 = Vector2.ZERO;
## For final friction value, Normal friction and Air Friction.
@onready var RealFriction:float = CharacterMovement.Friction;
## For final acceleration value, Normal acceleration and Air acceleration.
@onready var RealAcceleration:float = CharacterMovement.Acceleration;
## Final realspeed
@onready var RealSpeed:float = CharacterMovement.Speed;

#################################
#||                            ||
#||          Signals           ||
#||                            ||
#################################

signal OnReachMaximumSpeed
signal OnStopped
signal OnMoved

func _ready() -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING;

func _physics_process(delta: float) -> void:
	var physicsfps = Engine.physics_ticks_per_second;
	var target_speed = CharacterVelocity * CharacterMovement.Speed * physicsfps;
	# Horizontal Movement
	if ( target_speed.x != 0 ):
		if ( velocity.x != 0 && sign(velocity.x) != sign(target_speed.x) ):
			velocity.x = move_toward(velocity.x, 0, CharacterMovement.TurnSpeed*physicsfps);
		else:
			velocity.x = move_toward(velocity.x, target_speed.x, RealAcceleration*physicsfps);
	else:
		velocity.x = move_toward(velocity.x, 0, RealFriction*physicsfps);
	
	# Vertical Movement
	if ( target_speed.y != 0 ):
		if ( velocity.y != 0 && sign(velocity.y) != sign(target_speed.y) ):
			velocity.y = move_toward(velocity.y, 0, CharacterMovement.TurnSpeed*physicsfps);
		else:
			velocity.y = move_toward(velocity.y, target_speed.y, RealAcceleration*physicsfps);
	else:
		velocity.y = move_toward(velocity.y, 0, RealFriction*physicsfps);
	
	move_and_slide()
	
