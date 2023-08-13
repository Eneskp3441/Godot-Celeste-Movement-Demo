extends HBoxContainer


var value_func:Callable
@onready var val: Label = $val


func _process(delta: float) -> void:
	var _r = value_func.call()
	val.text = (_r if typeof(_r) == TYPE_STRING else "%.2f" % _r) if !typeof(_r) == TYPE_BOOL else ( "true" if _r else "false" )
