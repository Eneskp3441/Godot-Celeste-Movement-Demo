extends CharacterControllerPlatformer

@onready var sprite_2d: AnimatedSprite2D = $Player
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var character: CharacterControllerPlatformer = $"../.." as CharacterControllerPlatformer
@onready var dash_effects: SubViewport = $DashEffect/DashEffects
@onready var dash_particle: CPUParticles2D = $DashParticle


@onready var sub_viewport: SubViewport = $Hair/SubViewport

var squish:Vector2 = Vector2(1,1);
var wait = 0
var sprite_scale:Vector2 = Vector2(1,1);
@onready var dust_landed: CPUParticles2D = $DustLanded
var characterDirection:int = 1;
@onready var dash_effect = preload("res://Example/Scenes/dash_effect.tscn")
var dashEffectCount = 3;
var dashStartPos:Vector2;

@onready var hair: Line2D = $Hair/SubViewport/Hair
@onready var hairbase: Sprite2D = $Hair/SubViewport/hairbase
@onready var shockwave:ShockWave = get_tree().get_first_node_in_group("ShockWave") as ShockWave

@onready var default_z:int = z_index;
var dash_z:int = 3;

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

func _ready() -> void:
	Engine.time_scale = 1
#	onAir.connect(func(): print("havada"))
#	onFalling.connect(func(): state_machine.travel("fall"))
	onJump.connect(
		func(coyoto, buffer, is_wall_jump): 
#			state_machine.travel("jump");
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
		var _dif:Color = (HairColors.DEFAULT - hairColor);
		var _d = get_process_delta_time();
		if abs(_dif.r) > _d && abs(_dif.g) > _d && abs(_dif.b) > _d:
			self.hairColor = Color.WHITE;
			hair_deactive = .1;
	)
	
	onDash.connect(func(): hairTargetColor = HairColors.BLUE)
#	onDashFinished.connect(func(): self.hairColor = Color("#ad4045"))
	
	self.hairColor = hairColor;
	

var pos_different = Vector2();
func _physics_process(delta: float) -> void:
	if shockwave == null: shockwave = get_tree().get_first_node_in_group("ShockWave") as ShockWave
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
	pos_different = global_position;
	super._physics_process(delta);
	pos_different -= global_position;
	CharacterVelocity.x = input.x;
	squish = squish.slerp(Vector2(1,1), .2);
	sprite_2d.scale = sprite_scale * squish;
	if CharacterVelocity.x != 0:
		characterDirection = sign(CharacterVelocity.x); 
	
	
		
	if Input.is_action_just_pressed("jump"):
		Jump();
	elif Input.is_action_just_released("jump"):
		StopJump();
	
	if Input.is_action_just_pressed("dash") && CanDash():
		var _dir = Vector2(characterDirection, 0) if input == Vector2.ZERO else input;
		PixelPerfect2D.shake(_dir*1, .15)
		dash_particle.direction = _dir;
		Dash((_dir.angle()));
		squish.x = 1.4; 
		squish.y = .4;
		dashStartPos = global_position
		dashEffectCount = 3;
		shockwave.create(global_position, .25, 3, 0, 1, .1);
		OS.delay_msec(30)
	
	dash_particle.emitting = dashIsActive;
	
	if dashIsActive:
		var mod = round(dashStartPos.distance_to(global_position));
		if mod > 16 && dashEffectCount > 0:
			var inst = dash_effect.instantiate();
			var inst_sprite:= inst.get_node("SubViewport/Player") as AnimatedSprite2D;
			var img = ImageTexture.new()
			img.set_image(sub_viewport.get_texture().get_image());
			(inst.get_node("SubViewport/hair") as Sprite2D).texture = img;
#			(inst.get_node("hair") as Sprite2D).texture = sub_viewport.get_texture();
			dash_effects.add_child(inst)
			inst.global_position = global_position;
			inst_sprite.scale = sprite_2d.scale * 1.1;
			dashStartPos = global_position;
			inst_sprite.animation = sprite_2d.animation;
			inst_sprite.frame = sprite_2d.frame;
			dashEffectCount -= 1;
			
	sprite_scale.x = characterDirection;	
	wait = $Timer.time_left;
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.is_pressed() && event.button_index == MOUSE_BUTTON_LEFT:
		velocity.y = 0;
		global_position = get_global_mouse_position()

func _on_timer_timeout() -> void:
#	Jump();
	pass




