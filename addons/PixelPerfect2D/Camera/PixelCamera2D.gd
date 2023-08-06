@icon("res://addons/PixelPerfect2D/Assets/PixelPerfectCameraIcon.svg")

extends Camera2D

@export var smooth : float = 10;
@export var IntegerValues : bool = true;
@onready var CameraPosition : Vector2 = global_position;
@export var targetNode:Node2D;
@onready var window_scale : float = (Vector2(DisplayServer.window_get_size()) / PixelPerfect2D.GameSize).x


func _physics_process(delta: float) -> void:
	if is_instance_valid(targetNode):
		CameraPosition = lerp(CameraPosition, targetNode.global_position, delta * smooth) as Vector2;
		var subpixel_pos : Vector2 = CameraPosition.round() - CameraPosition;
		var _offset:Vector2 = Vector2(fmod(CameraPosition.x, 1.0), fmod(CameraPosition.y, 1.0))
		if IntegerValues: (PixelPerfect2D.PixelPerfectViewportContainer.material as ShaderMaterial).set_shader_parameter("cam_offset", _offset);
		global_position = CameraPosition.round() if IntegerValues else CameraPosition;
