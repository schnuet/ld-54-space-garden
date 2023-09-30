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
var mouse_inside = false;

var planted = false;

var type = "BHi";

func _ready():
	connect("mouse_entered", _on_mouse_entered);
	connect("mouse_exited", _on_mouse_exited);
	add_to_group("plant");

func set_state(new_state: GrowthState):
	growth_state = new_state;
	$AnimatedSprite2D.animation = GrowthState.keys()[new_state];

func _on_mouse_entered():
	mouse_inside = true;
	
func _on_mouse_exited():
	mouse_inside = false;

func _handle_click(mouse_position: Vector2):
	print("click handled on ", self);

func get_all_neighbour_plants():
	var build_collision_area = get_node("BuildCollisionArea") as Area2D;
	return build_collision_area.get_overlapping_areas();
	
func kill():
	queue_free();
	
func buff():
	pass
