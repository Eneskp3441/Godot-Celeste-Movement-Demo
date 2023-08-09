class_name ShockWave
extends Control


@onready var shockViewer:PackedScene = load("res://addons/Shockwave/Scenes/ShockWaveViewComp.tscn")
@onready var shockEffect:PackedScene = load("res://addons/Shockwave/Scenes/shock_effect.tscn")
@onready var shockTrail:PackedScene = load("res://addons/Shockwave/Scenes/ShockTrail.tscn")
var view:Control = null
var shockView:SubViewport = null
func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	name = "ShockWaveViewer"
	add_to_group("ShockWave")
	view = shockViewer.instantiate()
	add_child(view)
	shockView = view.get_node("SubViewport")
	get_viewport().size_changed.connect(update)
	update()

func create(pos:Vector2, strength=null, speed=null, fade=null, duration=null, startScale=null) -> void:
	var inst = shockEffect.instantiate()
	inst.position = pos
	if strength != null: inst.strength = strength
	if speed != null: inst.speed = speed
	if duration != null: inst.duration = duration
	if startScale != null: inst.startScale = startScale
	if fade != null: inst.fade = fade
	shockView.add_child(inst)


func update() -> void:
	size = get_viewport_rect().size
	shockView.size = get_viewport_rect().size
func createTrail(width:int, gradient:Gradient, curve:Curve) -> Line2D:
	var _inst = shockTrail.instantiate()
	_inst.width = width
	_inst.gradient = gradient
	_inst.width_curve = curve
	_inst.clear_points()
	shockView.add_child(_inst)
	return _inst
