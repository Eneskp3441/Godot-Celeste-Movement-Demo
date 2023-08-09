extends Node2D

@onready var hair: Sprite2D = $SubViewport/hair
@onready var view: Sprite2D = $View
@onready var sub_viewport: SubViewport = $SubViewport

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	view.modulate.a -= .25;
	visible = false;
	await get_tree().process_frame;
	visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	hair.global_position = -global_position + Vector2(32,32)
	if view.modulate.a > 0:
		view.modulate.a -= delta;
	else:
		queue_free()
