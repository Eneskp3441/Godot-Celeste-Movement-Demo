extends State


@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var character: CharacterControllerPlatformer = $"../.." as CharacterControllerPlatformer


func Enter() -> void:
	animation_player.play("fall")
	character.onLanded.connect(func(velocity_y):
		onTransitioned.emit(self, "idle");
	);
	
	
func Exit() -> void:
	pass

func Update(_delta:float) -> void:
	pass

func Physics_Update(_delta:float) -> void:
	if character.onWallSliding:
		onTransitioned.emit(self, "climb");
		
