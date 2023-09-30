extends Area2D

@export var plant_type: String = "";


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		print(plant_type);
		get_viewport().set_input_as_handled();
		Game.cursor_mode = plant_type;
