extends Node2D

func _ready() -> void:
	modulate.a -= .25;

func _process(delta: float) -> void:
	if modulate.a > 0:
		modulate.a -= delta;
	else:
		queue_free()
