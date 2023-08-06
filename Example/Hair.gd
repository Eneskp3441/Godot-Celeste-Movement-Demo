extends Node2D


@export var Length:int = 8;
@onready var hairbase: Sprite2D = $SubViewport/hairbase
@onready var max_width: int = 2

@onready var sub_viewport: SubViewport = $SubViewport
@onready var hairLine: Line2D = $SubViewport/Hair

var fakeHairCount = 0;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var pos = get_parent().global_position;
	var hair_offset := Vector2(1,4);
	hairbase.global_position = pos + Vector2(18+8,19+8);
	if ( get_parent().velocity.round() != Vector2.ZERO ):
		fakeHairCount = Length;
		var old_pos = hairLine.get_point_position(hairLine.get_point_count()-1)
		var prev_pos_diff = old_pos - pos
		hairLine.add_point(old_pos - prev_pos_diff + hair_offset);
		while hairLine.get_point_count() > Length: hairLine.remove_point(0);
		update_points()
	else:
		if fakeHairCount > 0:
			var x_offset = -get_parent().characterDirection*((fakeHairCount)*.5)
			hairLine.add_point(pos+hair_offset+Vector2(2+x_offset, fakeHairCount-2));
			fakeHairCount -= 1;
			while hairLine.get_point_count() > Length: hairLine.remove_point(0);
			update_points()
			
func update_points() -> void:
	var c = hairLine.get_point_count()
	for i in c:
		var r_index = c-1-i;
		if r_index != c-1:
			var point_old_pos = hairLine.get_point_position(r_index+1);
			var point_cur_pos = hairLine.get_point_position(r_index);
			var point_between_dif = point_old_pos-point_cur_pos;
			var new_pos = point_old_pos - point_between_dif.clamp(Vector2(-max_width, -max_width), Vector2(max_width,max_width))
			hairLine.set_point_position(r_index,new_pos)
