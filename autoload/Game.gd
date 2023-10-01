extends Node2D

signal cursor_mode_changed(mode);

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

func set_cursor_mode(mode):
	# disable
	if mode == cursor_mode:
		mode = "default";

	cursor_mode = mode;
	emit_signal("cursor_mode_changed", mode);
