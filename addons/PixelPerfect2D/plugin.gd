@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_autoload_singleton("PixelPerfect2D", "res://addons/PixelPerfect2D/Singleton.gd")
	add_custom_type("PixelPerfectCamera", "Camera2D",  preload("res://addons/PixelPerfect2D/Camera/PixelCamera2D.gd"), preload("res://addons/PixelPerfect2D/Assets/PixelPerfectCameraIcon.svg"));
	add_custom_type("PixelPerfectContainer", "Node2D",  preload("res://addons/PixelPerfect2D/Camera/PixelPerfectContainerNode.gd"), preload("res://addons/PixelPerfect2D/Assets/PixelPerfectContainer.svg"));
	add_custom_type("PixelViewportDrawing", "Node2D",  preload("res://addons/PixelPerfect2D/Camera/PixelViewportDrawing.gd"), preload("res://addons/PixelPerfect2D/Assets/PixelViewportDrawing.svg"));
	add_custom_type("CameraShakeComponent", "Node2D",  preload("res://addons/PixelPerfect2D/Camera/CameraShake.gd"), preload("res://addons/PixelPerfect2D/Assets/PixelPerfectCameraIcon.svg"));


func _exit_tree() -> void:
	remove_custom_type("PixelPerfectCamera");
	remove_custom_type("PixelPerfectContainer");
	remove_custom_type("PixelViewportDrawing");
	remove_custom_type("CameraShakeComponent");
	remove_autoload_singleton("PixelPerfect2D");
	
