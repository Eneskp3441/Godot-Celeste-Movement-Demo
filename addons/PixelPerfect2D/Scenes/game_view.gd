extends Control

var shockWave = ShockWave.new()
@onready var pixel_perfect_viewport: SubViewport = $PixelPerfectContainer/PixelPerfectViewport;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pixel_perfect_viewport.add_child(shockWave);
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED);
	Engine.max_fps = 60;

