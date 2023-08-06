extends State

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var character: CharacterControllerPlatformer = $"../.." as CharacterControllerPlatformer


func Enter() -> void:
	animation_player.play("idle")
	
	# jump
	character.onJump.connect(func(is_coyoto_jump, buffered, is_wall_jump):
		onTransitioned.emit(self, "jump");
	);
	
	# fall
	character.onFalling.connect(func():
		onTransitioned.emit(self, "fall");
	);
	
#	# turned
#	character.onTurned.connect(func(_dir):
#		onTransitioned.emit(self, "flip");
#	);
	

func Exit() -> void:
	pass

func Update(_delta:float) -> void:
	pass

func Physics_Update(_delta:float) -> void:
	if character.onWallSliding:
		onTransitioned.emit(self, "climb");
	elif abs(character.velocity.x * _delta) > .25:
		onTransitioned.emit(self, "run")
	
	
