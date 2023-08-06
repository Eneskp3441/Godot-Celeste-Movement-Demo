extends State


@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var character: CharacterControllerPlatformer = $"../.." as CharacterControllerPlatformer


func Enter() -> void:
	animation_player.play("jump");
	# fall
	character.onFalling.connect(func():
		onTransitioned.emit(self, "fall");
	);
	
	ParticleSystem.create(character, preload("res://Utils/ParticleSystem/Templates/dust.tscn"), character.global_position + Vector2(0, 2));

func Exit() -> void:
	pass

func Update(_delta:float) -> void:
	pass

func Physics_Update(_delta:float) -> void:
	if character.onWallSliding:
		onTransitioned.emit(self, "climb");
