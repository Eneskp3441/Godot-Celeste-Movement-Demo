class_name ParticleSystem extends Node

static func create(parent:Node,particle:PackedScene, pos:Vector2, count:int=8) -> CPUParticles2D:
	var inst := particle.instantiate() as CPUParticles2D;
	inst.amount = count;
	parent.add_child(inst);
	inst.global_position = pos;
	return inst;
