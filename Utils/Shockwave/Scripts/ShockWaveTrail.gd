@tool

class_name ShockWaveTrail
extends Line2D

@export_range(0,250, 1, "or_greater") var length:int = 50: 
	set(val):
		length = val
		if Engine.is_editor_hint():
			set_point_position(0, Vector2((length)*3., 0))
var shock_wave:Control = null
var active:bool = false;
var targetLine:Line2D = null

func _ready() -> void:
	show_behind_parent = true
	tree_exited.connect(func():
		if targetLine != null:
			targetLine.process_mode = Node.PROCESS_MODE_INHERIT
	)
	if Engine.is_editor_hint():
		add_point(Vector2(0,0))
		add_point(Vector2(-30,0))
		rotation = -PI
		width = 20
		var defaultTrailGradient = load("res://addons/Shockwave/Resources/defaultTrailGradient.tres")
		var defaultTrailCurve = load("res://addons/Shockwave/Resources/defaultTrailCurve.tres")
		width_curve = defaultTrailCurve
		gradient = defaultTrailGradient
	else:
		visible = false
	
	self.length = length

func _process(_delta: float) -> void:
	if !Engine.is_editor_hint():
		if shock_wave == null:
			shock_wave = get_tree().get_nodes_in_group("ShockWave")[0]		
			targetLine = shock_wave.createTrail(width, gradient, width_curve)	
		else:
			if targetLine != null && active:
				targetLine.global_position = Vector2.ZERO
				var _pos = global_position + get_point_position(1).rotated(global_rotation)
				targetLine.get_node("GPUParticles2D").global_position = _pos
				targetLine.add_point(_pos)
				if targetLine.get_point_count() > length:
					targetLine.remove_point(0)
			elif !active:
				targetLine.remove_point(0)

