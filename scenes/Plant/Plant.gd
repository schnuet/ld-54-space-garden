class_name Plant
extends Node2D

enum GrowthState {
	sapling,
	growing_1,
	growing_2,
	grown,
	dead
};

var growth_state: GrowthState = GrowthState.sapling;

func _ready():
	connect("input_event", _handle_click);

func set_state(new_state: GrowthState):
	growth_state = new_state;
	$AnimatedSprite2D.animation = GrowthState.keys()[new_state];


func _handle_click(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		print("click handled on ", self);
		get_viewport().set_input_as_handled();
