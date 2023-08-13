extends CharacterControllerPlatformer

@onready var sprite_2d: AnimatedSprite2D = $Player
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var character: CharacterControllerPlatformer = $"../.." as CharacterControllerPlatformer
@onready var dash_effects: SubViewport = $DashEffect/DashEffects
@onready var dash_particle: CPUParticles2D = $DashParticle
@onready var sub_viewport: SubViewport = $Hair/SubViewport
@onready var dust_landed: CPUParticles2D = $DustLanded
@onready var dash_effect = preload("res://CelesteExample/Scenes/dash_effect.tscn")
@onready var hair: Line2D = $Hair/SubViewport/Hair
@onready var hairbase: Sprite2D = $Hair/SubViewport/hairbase
@onready var shockwave:ShockWave = get_tree().get_first_node_in_group("ShockWave") as ShockWave
@onready var default_z:int = z_index;


var HairColors = {
	"DEFAULT"  : Color("#ad4045"),
	"BLUE"  : Color("#51b5ff"),
}
var hair_deactive:float = 0.0;
var hairColor:Color = HairColors.DEFAULT:
	set(val):
		hairColor = val;
		hair.modulate = hairColor;
		hairbase.modulate = hairColor;

var hairTargetColor:Color = hairColor;
var squish:Vector2 = Vector2(1,1);
var wait = 0
var sprite_scale:Vector2 = Vector2(1,1);
var dash_z:int = 3;
var dashEffectCount = 3;
var dashStartPos:Vector2;
var characterDirection:int = 1;


func _ready() -> void:
	## Squish effect when you jump.
	onJump.connect(
		func(coyoto, buffer, is_wall_jump): 
			if is_wall_jump:
				squish.x = .8; 
				squish.y = 1.1
			else:
				squish.x = .6; 
				squish.y = 1.4;
	)
	
	## Squish when you land and make the color of the hair white.
	onLanded.connect(func(vel):
		squish.x = 1.4; 
		squish.y = .6;
		var _dif:Color = (HairColors.DEFAULT - hairColor);
		var _d = get_process_delta_time();
		if abs(_dif.r) > _d && abs(_dif.g) > _d && abs(_dif.b) > _d:
			self.hairColor = Color.WHITE;
			hair_deactive = .1;
	)
	
	##When you dash, make the color of the hair blue.
	onDash.connect(func(): hairTargetColor = HairColors.BLUE)
	self.hairColor = hairColor;
	

func _physics_process(delta: float) -> void:
	if shockwave == null: shockwave = get_tree().get_first_node_in_group("ShockWave") as ShockWave
	
	## Input
	var input = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
	
	# Hair color
	if ( hairColor != hairTargetColor ):
		if hair_deactive <= 0:
			self.hairColor = hairColor.lerp(hairTargetColor, .2);
		else:
			hair_deactive -= delta;
	if is_on_floor() && !dashIsActive:
		hairTargetColor = HairColors.DEFAULT;
		
	
	
	## Squish Effect
	squish = squish.slerp(Vector2(1,1), .2);
	## Player direction:
	
	CharacterVelocity.x = input.x;
	if CharacterVelocity.x != 0:
		characterDirection = sign(CharacterVelocity.x); 
	
	sprite_scale.x = characterDirection;
	sprite_2d.scale = sprite_scale * squish;
	
	## jump
	if Input.is_action_just_pressed("jump"):
		Jump();
	elif Input.is_action_just_released("jump"):
		StopJump();
	
	
	## dash
	if Input.is_action_just_pressed("dash") && CanDash():
		## If the movement buttons are not pressed, dash in the direction he is looking.
		var _dir = Vector2(characterDirection, 0) if input == Vector2.ZERO else input;
		## Camera shake
		PixelPerfect2D.shake(_dir*1, .15);
		## particle direction 
		dash_particle.direction = _dir;
		Dash((_dir.angle()));
		## juice
		squish.x = 1.4; 
		squish.y = .4;
		dashStartPos = global_position
		## how many blue sprites to drop when dashing
		dashEffectCount = 3;
		## shockwave
		shockwave.create(global_position, .25, 3, 0, 1, .1);
		## freeze frame
		OS.delay_msec(30)
	## Dash particle
	dash_particle.emitting = dashIsActive;
	
	if dashIsActive:
		## every time you advance 16 pixels, create a blue sprite effect.
		var mod = round(dashStartPos.distance_to(global_position));
		if mod > 16 && dashEffectCount > 0:
			var inst = dash_effect.instantiate();
			var inst_sprite:= inst.get_node("Player") as AnimatedSprite2D;
			var img = ImageTexture.new()
			img.set_image(sub_viewport.get_texture().get_image());
			(inst.get_node("View") as Sprite2D).texture = img;
			dash_effects.add_child(inst)
			inst.global_position = global_position + Vector2();
			dashStartPos = global_position;
			inst_sprite.animation = sprite_2d.animation;
			inst_sprite.frame = sprite_2d.frame;
			dashEffectCount -= 1;
			
		
	## to execute the action codes of the superclass.
	super._physics_process(delta);

func _input(event: InputEvent) -> void:
	## (FOR DEBUG) ALLOWS IT TO BE RENDERED THERE WHEN YOU CLICK WITH THE MOUSE.
	if OS.is_debug_build():
		if event is InputEventMouseButton && event.is_pressed() && event.button_index == MOUSE_BUTTON_LEFT:
			velocity.y = 0;
			global_position = get_global_mouse_position()





