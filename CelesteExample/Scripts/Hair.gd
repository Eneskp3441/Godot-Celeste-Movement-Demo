@tool
extends Node2D


@export var Length:int = 8:
	set(val):
		Length = val
		if sub_viewport: sub_viewport.size = Vector2.ONE * Length * 4;
@onready var hairbase: Sprite2D = $SubViewport/hairbase
@onready var basepos:Vector2 = hairbase.position
@onready var max_width: int = 2
@onready var hairpivot: Marker2D = $Hairpivot
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@onready var character: CharacterControllerPlatformer = $".." as CharacterControllerPlatformer
@onready var sub_viewport: SubViewport = $SubViewport
@onready var hairLine: Line2D = $SubViewport/Hair
@onready var pivot_start := hairpivot.position;

var fakeHairCount = 0;


func _ready() -> void:
	if !Engine.is_editor_hint():
		character.onTurned.connect(_UpdateAnim)
	
	self.Length = Length;

func _process(delta: float) -> void:
	if !Engine.is_editor_hint():
		var pos = character.global_position;
		hairLine.global_position = sub_viewport.size*.5 - pos
		if ( get_parent().velocity.round() != Vector2.ZERO ):
			fakeHairCount = Length;
			hairLine.add_point(pos);
			while hairLine.get_point_count() > Length: hairLine.remove_point(0);
			update_points()
		else:
			if fakeHairCount > 0:
				var x_offset = -get_parent().characterDirection*((fakeHairCount)*1)
				hairLine.add_point(pos+Vector2(x_offset, fakeHairCount));
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
	if !Engine.is_editor_hint():
		var anim:Animation = animation_player.get_animation(animation_player.current_animation);
		if anim:
			var track = anim.find_track("Hair/Hairpivot:position", Animation.TYPE_VALUE);
			if track != -1:
				for key in anim.track_get_key_count(track):
					var cur_pos = anim.track_get_key_value(track, key);
					anim.track_set_key_value(track, key, Vector2(abs(cur_pos.x)*_dir, cur_pos.y));


func _on_animation_player_animation_started(anim_name: StringName) -> void:
	if !Engine.is_editor_hint():
		_UpdateAnim(character._last_turned_dir)
