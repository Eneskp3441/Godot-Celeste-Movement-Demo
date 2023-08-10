extends State

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var character: CharacterControllerPlatformer = $"../.." as CharacterControllerPlatformer


func Enter() -> void:
	animation_player.play("climb")
	
#	# turned
#	character.onTurned.connect(func(_dir):
#		onTransitioned.emit(self, "flip");
#	);
	

func Exit() -> void:
	pass

func Update(_delta:float) -> void:
	if timer < .5 && fmod(timer, _delta) <= _delta*.75:
		ParticleSystem.create(character.get_parent(), preload("res://Utils/ParticleSystem/Templates/dust.tscn"), character.global_position + Vector2(4 * character._last_turned_dir, -2));

func Physics_Update(_delta:float) -> void:
	if !character.onWall || character.onFloor:
		onTransitioned.emit(self, "idle")
	
	
