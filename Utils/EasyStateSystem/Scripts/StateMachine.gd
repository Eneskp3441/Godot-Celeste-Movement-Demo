class_name StateMachine extends Node

@export var initial_state : State;

var current_state : State;
var states : Dictionary = {};

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child;
			child.onTransitioned.connect(_on_child_transitioned)
	if initial_state:
		initial_state.Enter();
		initial_state.emit_signal("onEnter");
		current_state = initial_state;
func _process(delta: float) -> void:
	if current_state:
		current_state.Update(delta);
		current_state.timer += delta;


func _physics_process(delta: float) -> void:
	if current_state:
		current_state.Physics_Update(delta);

func _on_child_transitioned(state:State, new_state_name:String) -> void:
	if state != current_state:
		return;
	var new_state:State = states.get(new_state_name.to_lower()) as State;
	if new_state:
		if current_state:
			current_state.timer = 0;
			current_state.Exit();
			current_state.emit_signal("onExit");
		
		current_state = new_state;
		current_state.timer = 0;
		new_state.Enter()
		new_state.emit_signal("onEnter");
