@icon("res://Utils/EasyStateSystem/state_icon.svg")
class_name State extends Node

signal onInitialized;
signal onEnter;
signal onExit;
signal onTransitioned;
var timer:float = 0;

func Enter() -> void:
	pass

func Exit() -> void:
	pass

func Update(_delta:float) -> void:
	pass

func Physics_Update(_delta:float) -> void:
	pass
