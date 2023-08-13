extends State


@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var character: CharacterControllerPlatformer = $"../.." as CharacterControllerPlatformer


func Enter() -> void:
	animation_player.play("flip")
	animation_player.speed_scale = 3;
	animation_player.animation_finished.connect(func(_name:String):
		onTransitioned.emit(self, "idle");
	);

func Exit() -> void:
	animation_player.speed_scale = 1;

func Update(_delta:float) -> void:
	pass

func Physics_Update(_delta:float) -> void:
	pass
