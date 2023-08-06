extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ADAPTIVE)
	Engine.max_fps = 60;
