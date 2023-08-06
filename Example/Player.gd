extends CharacterControllerPlatformer

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

var squish:Vector2 = Vector2(1,1);
var wait = 0
var sprite_scale:Vector2 = Vector2(1,1);
@onready var dust_landed: CPUParticles2D = $DustLanded
var characterDirection:int = 1;
func _ready() -> void:
	sprite_2d.play("idle")
	
#	onAir.connect(func(): print("havada"))
#	onFalling.connect(func(): print("düşüyor"))
	onJump.connect(
		func(coyoto, buffer, is_wall_jump): 
			dust_landed.emitting = true;
			if is_wall_jump:
				squish.x = .8; 
				squish.y = 1.1
			else:
				squish.x = .6; 
				squish.y = 1.4;
	)
	onLanded.connect(func(vel):
		squish.x = 1.4; 
		squish.y = .6;
		dust_landed.emitting = true;
	)

var pos_different = Vector2();
func _physics_process(delta: float) -> void:
	pos_different = global_position;
	super._physics_process(delta);
	pos_different -= global_position;
	CharacterVelocity.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left");
	squish = squish.slerp(Vector2(1,1), .2);
	sprite_2d.scale = sprite_scale * squish;
	if CharacterVelocity.x != 0:
		characterDirection = sign(CharacterVelocity.x); 
	
	# Animations
	if ( abs(velocity.x*delta) > .25 ):
		sprite_2d.play("run")
	else:
		sprite_2d.play("idle")
		
	if Input.is_action_just_pressed("jump"):
		Jump();
	elif Input.is_action_just_released("jump"):
		StopJump();
	sprite_scale.x = characterDirection;	
	wait = $Timer.time_left;

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.is_pressed():
		velocity.y = 0;
		global_position = get_global_mouse_position()

func _on_timer_timeout() -> void:
#	Jump();
	pass
