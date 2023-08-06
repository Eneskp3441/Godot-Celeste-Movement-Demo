extends SubViewportContainer

@onready var _SubViewport = $PixelPerfectViewport
func _ready() -> void:
	PixelPerfect2D.PixelPerfectViewportContainer = self;
	PixelPerfect2D.PixelPerfectViewport = $PixelPerfectViewport;
	update_canvas()
	


func update_canvas() -> void:
	var viewport_size = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), ProjectSettings.get_setting("display/window/size/viewport_height"));
	var shrink_scale = viewport_size.x / PixelPerfect2D.GameSize.x;
	
	print(PixelPerfect2D.GameSize.x,  " view", viewport_size.x,"scale",shrink_scale)
	
	_SubViewport.set_owner(get_tree().edited_scene_root)
	_SubViewport.name = "PixelPerfectViewport";
	_SubViewport.size = PixelPerfect2D.GameSize + Vector2(2, 2);
	print(_SubViewport.size)
	_SubViewport.disable_3d = true;
	_SubViewport.canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST;
	
	set_owner(get_tree().edited_scene_root)
	name = "PixelPerfectContainer";
	stretch = true;
	stretch_shrink = shrink_scale;
	layout_mode = 1;
	set_anchors_preset(Control.PRESET_FULL_RECT);
	size =  viewport_size + Vector2(2, 2) * shrink_scale;
	position -= Vector2(1, 1) * shrink_scale;
	set_script(preload("res://addons/PixelPerfect2D/Camera/PixelPerfectContainer.gd"));
	
	var CamMaterial:ShaderMaterial = ShaderMaterial.new()
	CamMaterial.shader = preload("res://addons/PixelPerfect2D/Materials/SmoothCam.gdshader");
	material = CamMaterial;
	
	
	
