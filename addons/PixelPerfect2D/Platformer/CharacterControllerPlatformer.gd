class_name CharacterControllerPlatformer extends "res://addons/PixelPerfect2D/Platformer/CharacterController.gd"


#################################
#||                            ||
#||          SIGNALS           ||
#||                            ||
#################################

signal onLanded(velocity_y)
signal onJump(is_coyoto_jump, buffered, is_wall_jump)
signal onAir
signal onFalling
signal onTurned(direction)


#################################
#||                            ||
#||         Variables          ||
#||                            ||
#################################

var isFalling:bool = false;
var onFloor:bool = false;
var onCeil:bool = false;
var onWall:bool = false;
var jumpingPressed:int = 0;
var jumping:bool = false;
var falledVelocity:float = 0.;
var wallDirection:int = 1;
var rightWall:bool = false;
var leftWall:bool = false;
var onWallSliding:bool = false;
var onEdge:bool = false;


var _rem_jumpbuffer:float	 = 0.;
var _rem_coyoto_time:float = 0.;
var _gravity_multiplier:float = 1.;
var _gravity_scale:float = 0.;
var _control:float = 1.;
var _grav_max:float = 1.;
var _last_jump_type := 0;
var _last_turned_dir:int = 1;
var _bufferedJumpStrength:float = 0.;
func _ready() -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_GROUNDED;
	onLanded.connect(_onLanded);


func _physics_process(delta: float) -> void:
	physicsfps = 1. / delta;
	if !onFloor && is_on_floor(): _onLanded(falledVelocity); emit_signal("onLanded", falledVelocity)
	if onFloor && !is_on_floor(): emit_signal("onAir")
	onFloor = is_on_floor();
	onCeil  = is_on_ceiling();
	rightWall  = test_move(transform, Vector2(CharacterMovement.Wall_SafeMargin,0));
	leftWall  = test_move(transform, Vector2(-CharacterMovement.Wall_SafeMargin,0));
	onWall = rightWall || leftWall;
	
	onEdge = !test_move(global_transform.translated(Vector2(CharacterMovement.EdgeCheckDistance*_last_turned_dir,1)), Vector2(0,1))
	
	if sign(CharacterVelocity.x) != 0 && _last_turned_dir != sign(CharacterVelocity.x) && sign(CharacterVelocity.x) != sign(velocity.x):
		_last_turned_dir = sign(CharacterVelocity.x);
		onTurned.emit(_last_turned_dir)
		
	# calc wall direction
	if onWall: wallDirection = 1 if rightWall else -1
	var activeWallValue = ( velocity.y  > 0 && onWall && (wallDirection == sign(CharacterVelocity.x) || !CharacterMovement.Wall_OnlyWhenMoving ) ) && CharacterMovement.Wall_active;
	onWallSliding = activeWallValue
	_gravity_scale = CharacterMovement.Wall_Gravity if activeWallValue else CharacterMovement.Gravity;	
	var target_speed = CharacterVelocity * CharacterMovement.Speed * physicsfps;
	if deactive_input > 0: target_speed = Vector2.ZERO;
	_grav_max = CharacterMovement.Wall_GravityMax if activeWallValue else CharacterMovement.GravityMaximum
	if move_cooldown.x <= 0:
		# Horizontal Movement
		if ( target_speed.x != 0 ):
			if ( cVelocity.x != 0 && sign(cVelocity.x) != sign(target_speed.x) ):
				cVelocity.x = move_toward(cVelocity.x, 0, CharacterMovement.TurnSpeed*physicsfps*_control);
			else:
				cVelocity.x = move_toward(cVelocity.x, target_speed.x, RealAcceleration*physicsfps*_control);
		else:
			cVelocity.x = move_toward(cVelocity.x, 0, RealFriction*physicsfps*_control);
	## APPLY GRAVITY
	if (!onFloor && move_cooldown.y <= 0):
		cVelocity.y = move_toward(cVelocity.y, _grav_max*physicsfps, _gravity_scale*_gravity_multiplier*physicsfps);
	
	_rem_coyoto_time = move_toward(_rem_coyoto_time, 0,delta)
	_rem_jumpbuffer = move_toward(_rem_jumpbuffer, 0,delta)
	deactive_input = move_toward(deactive_input, 0,delta)
	move_cooldown.x = move_toward(move_cooldown.x, 0, delta);
	move_cooldown.y = move_toward(move_cooldown.y, 0, delta);
	
	_HandleJump()
	_CalculateGravity();
	velocity = cVelocity
	CalcCornerCorrection()
	move_and_slide()
	cVelocity = velocity;
	if is_on_floor():
		dashRemaining = CharacterMovement.Dash_Count;
	
	motion = global_position - _old_position;
	_old_position = global_position;
## Character Jump Event - you have to run it as long as the button is pressed 
## Usage
## [codeblock]
## if Input.is_action_just_pressed("jump"):
## 		Jump()
## [/codeblock]
var _prev_jumped = false;
func Jump() -> void:
	jumpingPressed = 1;
	_prev_jumped = true
	
## Usage
## [codeblock]
## if Input.is_action_just_released("jump"):
## 		StopJump()
## [/codeblock]
func StopJump() -> void:
	if _prev_jumped:
		jumpingPressed = -1;
		_prev_jumped = false;

func _HandleJump() -> void:
	# Relase Jump
	if jumpingPressed < 0:
		jumpingPressed = 0
		
		_bufferedJumpStrength /= CharacterMovement.JumpCutoff;
		if !onFloor && !dashIsActive:
				cVelocity.y /= CharacterMovement.JumpCutoff;
	# Jump Pressed
	if jumpingPressed > 0 || _rem_jumpbuffer > 0:
		if onFloor || _rem_coyoto_time > 0:
			var is_buffered:bool = _rem_jumpbuffer > 0;
			_last_jump_type = 1;
			_rem_coyoto_time = 0;
			var jumpH = (CharacterMovement.JumpHeight if !is_buffered else _bufferedJumpStrength  ) * CharacterMovement.GravityScale * physicsfps;
			cVelocity.y = -jumpH;
			jumping = true;
			if jumpingPressed: 
				_rem_jumpbuffer = 0;
		else: 
			if onWall && velocity.y > 0:
				_last_jump_type = 2;
				var offset = CharacterMovement.Wall_JumpOffsetMin if CharacterVelocity.x == 0 else CharacterMovement.Wall_JumpOffset;
				var jumph = CharacterMovement.Wall_JumpHeightMin if CharacterVelocity.x == 0 else CharacterMovement.Wall_JumpHeight;
				cVelocity.y = -jumph * CharacterMovement.GravityScale * physicsfps;
				cVelocity.x = -wallDirection * offset * physicsfps;
				if CharacterVelocity.x != 0: deactive_input = CharacterMovement.Wall_JumpInputCooldown;
				if jumpingPressed: 
					_rem_jumpbuffer = CharacterMovement.Wall_JumpBuffer;
					_bufferedJumpStrength = CharacterMovement.Wall_JumpHeight;
			else:
				if jumpingPressed: 
					_rem_jumpbuffer = CharacterMovement.Wall_JumpBuffer if _last_jump_type == 2 else CharacterMovement.JumpBuffer;
					_bufferedJumpStrength = CharacterMovement.Wall_JumpHeight if _last_jump_type == 2 else CharacterMovement.JumpHeight;
				_last_jump_type = 0;
		if _last_jump_type != 0: emit_signal("onJump", !onFloor && _rem_coyoto_time > 0, _rem_jumpbuffer > 0, _last_jump_type == 2)
		jumpingPressed = 0

func _CalculateGravity() -> void:
	# Going up
	if ( cVelocity.y < 0 ):
		isFalling = false;
		if ( onFloor ):
			_control =  1;
			RealAcceleration = CharacterMovement.Acceleration;
			RealFriction = CharacterMovement.Friction;
			_gravity_multiplier = CharacterMovement.GravityScale;
		else:
			_control =  CharacterMovement.AirControl;
			RealAcceleration = CharacterMovement.AirAcceleration;
			RealFriction = CharacterMovement.AirBrake;
			if ( jumpingPressed && jumping ):
				pass
			_gravity_multiplier = CharacterMovement.UpGravity;

		falledVelocity = 0.;
	# Going down
	elif ( cVelocity.y > 0 ):
		if ( onFloor ):
			_control =  1;
			RealAcceleration = CharacterMovement.Acceleration;
			RealFriction = CharacterMovement.Friction;
			_gravity_multiplier = CharacterMovement.GravityScale;
		else:
			if !isFalling: emit_signal("onFalling")
			isFalling = true;
			RealAcceleration = CharacterMovement.AirAcceleration;
			RealFriction = CharacterMovement.AirBrake;
			_control =  CharacterMovement.AirControl;
			_gravity_multiplier = CharacterMovement.DownGravity;
		falledVelocity = max(falledVelocity, cVelocity.y)
	else:
		if ( onFloor ):
			isFalling = false;
			_control =  1;
			RealAcceleration = CharacterMovement.Acceleration;
			RealFriction = CharacterMovement.Friction;
			_rem_coyoto_time = CharacterMovement.CoyotoTime;
			jumping = false;
			jumpingPressed = false
		_gravity_multiplier = CharacterMovement.GravityScale;

func _onLanded(velocity_y) -> void:
	onFloor = true;
	jumpingPressed = false;


func CalcCornerCorrection() -> void:
	var delta = get_physics_process_delta_time();
	# Vertical
	if velocity.y < 0 && test_move(global_transform, Vector2(0, velocity.y*delta)):
		for i in range(1, CharacterMovement.CornerCorrectionSize+1):
			for j in [-1., 1.]:
				if !test_move(global_transform.translated(Vector2(i*j, 0)), Vector2(0, velocity.y * delta)):
					translate(Vector2(i*j, 0));
					return;
	# Horizontal
	if abs(velocity.y) < CharacterMovement.Gravity && velocity.x != 0 && test_move(global_transform, Vector2(velocity.x*delta, 0)):
		for i in range(1, CharacterMovement.CornerCorrectionSize+2):
			for j in [-1., 1.]:
				if !test_move(global_transform.translated(Vector2(0, i*j)), Vector2(velocity.x * delta, 0)):
					translate(Vector2(0, i*j));
					return;
