@tool
extends Node2D

@export var LineColor:Color = Color("00ffff64"):
	set(val): LineColor = val; queue_redraw();
@export var LineWidth:float = 1.:
	set(val): LineWidth = val; queue_redraw();

func _ready() -> void:
	z_index = 100;
	if !Engine.is_editor_hint(): queue_free();

func _draw() -> void:
	draw_rect(Rect2i(0,0, PixelPerfect2D.GameSize.x, PixelPerfect2D.GameSize.y), LineColor, false, LineWidth);
