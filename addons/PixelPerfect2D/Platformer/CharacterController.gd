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



var physicsfps:int = 0;
var cVelocity:Vector2 = Vector2.ZERO;
var deactive_input:float = 0.;
var move_cooldown:Vector2 = Vector2(0.,0.);
var dashIsActive:bool = false;
var dashRemaining:int = 0;
#################################
#||                            ||
#||          Signals           ||
#||                            ||
#################################

signal OnReachMaximumSpeed
signal OnStopped
signal OnMoved
signal onDash
signal onDashFinished

func _ready() -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING;

func _physics_process(delta: float) -> void:
	physicsfps = 1. / delta;
	var target_speed = CharacterVelocity * CharacterMovement.Speed * physicsfps;
	if deactive_input > 0: target_speed = Vector2.ZERO;
	# Horizontal Movement
	if move_cooldown.x <= 0:
		if ( target_speed.x != 0 ):
			if ( cVelocity.x != 0 && sign(cVelocity.x) != sign(target_speed.x) ):
				cVelocity.x = move_toward(cVelocity.x, 0, CharacterMovement.TurnSpeed*physicsfps);
			else:
				cVelocity.x = move_toward(cVelocity.x, target_speed.x, RealAcceleration*physicsfps);
		else:
			cVelocity.x = move_toward(cVelocity.x, 0, RealFriction*physicsfps);
	
	# Vertical Movement
	if move_cooldown.y <= 0:
		if ( target_speed.y != 0 ):
			if ( cVelocity.y != 0 && sign(cVelocity.y) != sign(target_speed.y) ):
				cVelocity.y = move_toward(cVelocity.y, 0, CharacterMovement.TurnSpeed*physicsfps);
			else:
				cVelocity.y = move_toward(cVelocity.y, target_speed.y, RealAcceleration*physicsfps);
		else:
			cVelocity.y = move_toward(cVelocity.y, 0, RealFriction*physicsfps);
	
	velocity = cVelocity;
	move_and_slide()
	cVelocity = velocity;
	if is_on_floor():
		dashRemaining = CharacterMovement.Dash_Count;
		
	deactive_input = move_toward(deactive_input, 0,delta)
#	move_cooldown = move_cooldown.move_toward(Vector2.ZERO, delta);
	move_cooldown.x = move_toward(move_cooldown.x, 0, delta);
	move_cooldown.y = move_toward(move_cooldown.y, 0, delta);
	
func Dash(direction:float):
		dashRemaining -= 1;
		var multiplier:Vector2 = Vector2.ONE;
		var _d = round(rad_to_deg(direction))
		if _d == 0: multiplier.x = CharacterMovement.Dash_right_scale;
		elif _d == 180: multiplier.x = CharacterMovement.Dash_left_scale;
		elif _d >= -90-45 && _d <= -90+45: multiplier.y = CharacterMovement.Dash_up_scale;
		elif _d == 90: multiplier.y = CharacterMovement.Dash_down_scale;
		var speed = Vector2.RIGHT.rotated((direction) );
		cVelocity = speed * CharacterMovement.Dash_Strength * multiplier * physicsfps;
		deactive_input = CharacterMovement.Dash_input_cooldown;
		move_cooldown = Vector2(.5, 1) * CharacterMovement.Dash_input_cooldown;
		dashIsActive = true;
		onDash.emit();
		await get_tree().create_timer(CharacterMovement.Dash_Strength * CharacterMovement.Dash_input_cooldown).timeout;
		dashIsActive = false;
		onDashFinished.emit();
	
	

func CanDash() -> bool:
	return dashRemaining > 0;
