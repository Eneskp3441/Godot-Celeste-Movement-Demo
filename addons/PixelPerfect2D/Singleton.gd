@tool

extends Node

# EDITABLE
var GameSize:Vector2 = Vector2(320, 180);


## OTHER
var PixelPerfectViewportContainer:SubViewportContainer;
var PixelPerfectViewport:SubViewport;

func shake(_amplitude:Vector2, _duration:float):
	var cam:Camera2D = PixelPerfectViewport.get_camera_2d();
	if cam:
		for shake in cam.get_children():
			if shake is CameraShake:
				shake.duration = _duration;
				shake.time_left = _duration;
				shake.amplitude = _amplitude;
