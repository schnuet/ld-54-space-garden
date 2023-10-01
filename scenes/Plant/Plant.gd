class_name Plant
extends Node2D

var type = "BHi";

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D; # get the sprite

enum GrowthState {
	sapling,
	mid,
	final,
	infected
};

# flags
var mouse_inside = false;
var planted = false;
var neutralize_count = 0;


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



func get_all_neighbour_plants() -> Array[Plant]:
	await get_tree().physics_frame
	
	var plants:Array[Plant] = [];
	
	var build_collision_area = get_node("BuildCollisionArea") as Area2D;
	var areas = build_collision_area.get_overlapping_areas() as Array[Plant];
	
	for area in areas:
		if area == self:
			continue;
		if not (area is Plant):
			continue;
		if not area.planted:
			continue;
		plants.append(area);
	
	return plants;

	
func kill():
	print("KILL ", type);
	queue_free();
	
func buff():
	print("BUFF ", type);
	buffs += buff_amount;

func nerf():
	print("NERF ", type);
	buffs -= buff_amount;
	
func neutralize():
	print("NEUTRALIZE ", type);
	neutralize_count += 1;
	
func deneutralize():
	print("DENEUTRALIZE ", type);
	neutralize_count -= 1;

func is_neutralized():
	return neutralize_count > 0;


func affect_plant(plant: Plant):
	pass

func transform_to_plant(plant: Plant):
	var map = get_tree().get_first_node_in_group("plant_map") as PlantMap;
	var current_pos = global_position;
	queue_free();
	map.create_plant(plant.type, current_pos);

func _on_state_change(new_state: GrowthState, old_state: GrowthState):
	pass

func change_to_state(new_state: GrowthState):
	if new_state == growth_state:
		return;
		
	print("change state of ", type, " to ", GrowthState.keys()[new_state]);
	var old_state = growth_state;
	growth_state = new_state;
	
	if growth_state == GrowthState.final:
		grow_timer.stop();
	
	_on_state_change(new_state, old_state);
	
	# update animation
	sprite.animation = GrowthState.keys()[growth_state];


func _on_plant():
	change_to_state(GrowthState.sapling);
	planted = true;
	await get_tree().physics_frame;



func _on_grow_timer():
	if not planted:
		return;
	
	# only grow if we're not in the final state
	if growth_state != GrowthState.sapling and growth_state != GrowthState.mid:
		return;

	grow_points += max(grow_speed + buffs, 0);
	
	if grow_points >= 100:
		change_to_state(GrowthState.final);
	elif grow_points >= 50:
		change_to_state(GrowthState.mid);
	else:
		change_to_state(GrowthState.sapling);



# Click handlers

func _on_mouse_entered():
	mouse_inside = true;
	
func _on_mouse_exited():
	mouse_inside = false;

func _handle_click(mouse_position: Vector2):
	print("plant click ", self);
