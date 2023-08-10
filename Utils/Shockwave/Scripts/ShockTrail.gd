extends Line2D

func _process(_delta: float) -> void:
	modulate.a *= .95
	if(modulate.a <= 0): queue_free()
