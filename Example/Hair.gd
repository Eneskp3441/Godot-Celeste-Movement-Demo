extends Node2D


@export var Length:int = 8;
@onready var hairbase: Sprite2D = $SubViewport/hairbase
@onready var basepos:Vector2 = hairbase.position
@onready var max_width: int = 2
@onready var hairpivot: Marker2D = $Hairpivot
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@onready var character: CharacterControllerPlatformer = $".." as CharacterControllerPlatformer
@onready var sub_viewport: SubViewport = $SubViewport
@onready var hairLine: Line2D = $SubViewport/Hair

var fakeHairCount = 0;
func _ready() -> void:
	character.onTurned.connect(_UpdateAnim)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var pos = character.global_position + Vector2(0, -11);
	var hair_offset := Vector2(0,12);
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
			hairLine.add_point(pos+hair_offset+Vector2(1+x_offset, fakeHairCount-2));
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


func _UpdateAnim(_dir) -> void:
	var anim:Animation = animation_player.get_animation(animation_player.current_animation);
	if anim:
		var track = anim.find_track("Hair/Hairpivot:position", Animation.TYPE_VALUE);
		if track != -1:
			for key in anim.track_get_key_count(track):
				var cur_pos = anim.track_get_key_value(track, key);
				anim.track_set_key_value(track, key, Vector2(abs(cur_pos.x)*_dir, cur_pos.y));


func _on_animation_player_animation_started(anim_name: StringName) -> void:
	_UpdateAnim(character._last_turned_dir)
