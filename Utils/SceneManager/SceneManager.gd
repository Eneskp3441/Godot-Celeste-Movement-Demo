@tool
@icon("res://Utils/SceneManager/icon.svg")
class_name SceneManager extends Node

@export var MainNodes:Array[Node];
@export var GameView:Node;
@export var TransitionNode:Node;

func _enter_tree() -> void:
	check()
		

func _ready() -> void:
	if !Engine.is_editor_hint():
		add_to_group("SceneManager");
	get_tree().node_removed.connect(check)

static func change(scene_path:String):
	pass

func check(node:Node=null) -> void:
	print("Tr node: ", TransitionNode, " deleted node: ", node)
	if TransitionNode == node:
		print("null")
		TransitionNode = null;
	var _tr = find_child("Transition");
	if _tr != null:
		if TransitionNode == null:
			TransitionNode = _tr;
	else:
		if TransitionNode == null:
			var Transition = Control.new();
			add_child.call_deferred(Transition);
			Transition.set_owner.call_deferred(self);
			Transition.name = "Transition";
			TransitionNode = Transition;

