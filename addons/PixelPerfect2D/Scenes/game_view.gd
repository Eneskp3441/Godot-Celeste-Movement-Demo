extends Control

var shockWave = ShockWave.new()
@onready var pixel_perfect_viewport: SubViewport = $PixelPerfectContainer/PixelPerfectViewport

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pixel_perfect_viewport.add_child(shockWave);
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ADAPTIVE)
	Engine.max_fps = 60;


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.is_pressed():
		pass
#		shockWave.create(pixel_perfect_viewport.get_mouse_position() + Vector2(64,64), 1, 1, 3, .25);
