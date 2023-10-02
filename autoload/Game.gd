extends Node2D

signal cursor_mode_changed(mode);

var anim_frame = 0;

# Space for game-wide variables
enum PlantType {
	BHi,
	B,
	C,
	D,
	E,
	F
};

var cursor_mode = "default";

var found_infection = false;
@onready var frame_timer = Timer.new();

func _ready():
	add_child(frame_timer);
	frame_timer.start(0.5681);
	frame_timer.connect("timeout", update_anim);

func set_cursor_mode(mode):
	cursor_mode = mode;
	emit_signal("cursor_mode_changed", mode);

func wait(seconds):
	return await get_tree().create_timer(seconds).timeout;


func init_vars():
	cursor_mode = "default";
	found_infection = false;

func update_anim():
	anim_frame = (anim_frame + 1) % 4;
