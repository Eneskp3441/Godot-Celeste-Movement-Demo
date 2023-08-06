@tool
extends Node

func _enter_tree() -> void:
	if Engine.is_editor_hint():
		name = "@PixelPerfectContainer"
		var ViewportContainer:SubViewportContainer = SubViewportContainer.new();
		var _SubViewport:SubViewport = SubViewport.new();
		
		get_parent().add_child(ViewportContainer);
		ViewportContainer.add_child(_SubViewport);
		ViewportContainer.update_canvas()
		queue_free()

