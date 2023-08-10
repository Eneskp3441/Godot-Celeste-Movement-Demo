extends Sprite2D

var startScale = .5;
var speed:float = 1;
var strength:float = 1.0;
var duration:float = 1;
var fade:float = 0;

func _ready() -> void:
	scale = Vector2(startScale * .25, startScale * .25)
	modulate.a = strength;

func _process(delta: float) -> void:
#	delta = 0.008
	scale *= 1.02 + (speed * delta);
	delta = 0.008
	if fade <= 0:
		modulate.a = lerp(modulate.a, 0.0, (1./duration) * delta * speed * 5.);
	else:
		fade -= delta;
	if modulate.a < delta:
		queue_free()
