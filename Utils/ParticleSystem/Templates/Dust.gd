extends CPUParticles2D

@onready var rem_time:float =  lifetime;
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _ready() -> void:
	emitting = 1;

func _process(delta: float) -> void:
	rem_time -= delta;
	if rem_time < 0:
		queue_free()
