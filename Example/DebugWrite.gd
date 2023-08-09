extends MarginContainer
@onready var v_box_container: VBoxContainer = $VBoxContainer

@onready var player:CharacterControllerPlatformer = get_tree().get_first_node_in_group("player");
var debug = [
	["CoyotoTime", func(): return player._rem_coyoto_time],
	["JumpBuffer", func(): return player._rem_jumpbuffer],
	["Gravity Multiplier", func(): return player._gravity_multiplier],
	["Is falling", func(): return player.isFalling],
	["On floor", func(): return player.onFloor],
	["On ceil", func(): return player.onCeil],
	["On wall", func(): return player.onWall],
	["jumping", func(): return player.jumping],
	["falled Velocity", func(): return player.falledVelocity*get_process_delta_time()],
	["velocity x", func(): return player.velocity.x*get_process_delta_time()],
	["velocity y", func(): return player.velocity.y*get_process_delta_time()],
	["move cooldown x", func(): return player.move_cooldown.x],
	["move cooldown y", func(): return player.move_cooldown.y],
	["onEdge", func(): return player.onEdge],
	["dashIsActive", func(): return player.dashIsActive],
]

var box = preload("res://Example/box.tscn")

func _ready() -> void:
	for i in debug:
		var inst = box.instantiate();
		v_box_container.add_child(inst);
		inst.value_func = i[1]
		inst.get_node("name").text = i[0]
