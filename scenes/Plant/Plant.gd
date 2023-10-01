class_name Plant
extends Node2D

var type = "BHi";

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D; # get the sprite

enum GrowthState {
	sapling,
	mid,
	final
};

# flags
var mouse_inside = false;
var planted = false;


# growth
var growth_state: GrowthState = GrowthState.sapling;
var grow_points = 0;  # 0-100, 100 is grown
var grow_speed = 5;
var buff_amount = 3;
@onready var grow_timer = Timer.new();
var buffs = 0;

func _ready():
	connect("mouse_entered", _on_mouse_entered);
	connect("mouse_exited", _on_mouse_exited);
	add_to_group("plant");
	
	grow_timer.wait_time = 1; # 1 second
	grow_timer.connect("timeout", _on_grow_timer);
	add_child(grow_timer);
	grow_timer.start();
	
	sprite.play();

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

func _on_plant():
	await get_tree().physics_frame;
	planted = true;
	pass
	
func kill():
	queue_free();
	
func buff():
	buffs += buff_amount;

func nerf():
	buffs -= buff_amount;

func _on_grow_timer():
	if not planted:
		return;

	grow_points += max(grow_speed + buffs, 0);
	
	if grow_points >= 100:
		growth_state = GrowthState.final;
		grow_timer.stop();
	elif grow_points >= 50:
		growth_state = GrowthState.mid;
	else:
		growth_state = GrowthState.sapling;
	
	# update animation
	sprite.animation = GrowthState.keys()[growth_state];
