class_name PlantMap
extends Node2D

# 4*6
signal level_changed(level_index);
signal level_done(level_index);

@onready var plants_group:Node2D = $Plants;

@onready var Plant = preload("res://scenes/Plant/Plant.tscn");
@onready var PlantBHi = preload("res://scenes/Plant/1 - BHi/PlantBHi.tscn");
@onready var PlantStan = preload("res://scenes/Plant/2 - Stan/PlantStan.tscn");
@onready var PlantJeff = preload("res://scenes/Plant/3 - Jeff/PlantJeff.tscn");
@onready var PlantAssi = preload("res://scenes/Plant/4 - Assi/PlantAssi.tscn");
@onready var PlantFrank = preload("res://scenes/Plant/5 - Frank/PlantFrank.tscn");
@onready var PlantToni = preload("res://scenes/Plant/6 - Toni/PlantToni.tscn");

@onready var timer = Timer.new();

@onready var plants_by_name = {
	"BHi": PlantBHi,
	"Assi": PlantAssi,
	"Frank": PlantFrank,
	"Jeff": PlantJeff,
	"Stan": PlantStan,
	"Toni": PlantToni,
};

var tile_size = 64;


var levels = [
	{
		"id": 1,
		"requires_filled_board": true,
		"required_plants": {
			"BHi": 3
		}
	},
	{
		"id": 2,
		"requires_filled_board": true,
		"required_plants": {
			"BHi": 3,
			"Stan": 1,
		}
	},
	{
		"id": 3,
		"requires_filled_board": false,
		"required_plants": {
			"BHi": 2,
			"Stan": 1,
			"Jeff": 1
		}
	},
	{
		"id": 4,
		"requires_filled_board": false,
		"required_plants": {
			"BHi": 1,
			"Stan": 1,
			"Jeff": 1,
			"Assi": 1
		}
	},
	{
		"id": 5,
		"requires_filled_board": false,
		"required_plants": {
			"BHi": 1,
			"Stan": 2,
			"Jeff": 1,
			"Assi": 1,
			"Frank": 1
		}
	},
	{
		"id": 6,
		"requires_filled_board": true,
		"required_plants": {
			"BHi": 1,
			"Stan": 1,
			"Jeff": 1,
			"Assi": 1,
			"Frank": 1,
			"Toni": 1
		}
	}
];

var spaces = {
	"BHi": 1,
	"Stan": 3,
	"Jeff": 3,
	"Assi": 2,
	"Frank": 5,
	"Toni": 4
};

var current_level_index = 0;

var paused = false;

func _ready():
	#start the game after a small delay
	get_tree().create_timer(0.1).connect("timeout", start);
	
	add_child(timer);
	timer.one_shot = true;
	
	Game.connect("cursor_mode_changed", _on_cursor_mode_change);

func start():
	print("start");
#	current_level_index = -1;
#	update_level();
	emit_signal("level_done", -1);
#
func _physics_process(delta):
		# position build cursor
	var mouse_tile_pos = get_mouse_tile_pos();
	var tile_pos = Vector2i(
		clamp(mouse_tile_pos.x, 0, 7),
		clamp(mouse_tile_pos.y, 0, 2)
	);
	
	var x = mouse_tile_pos.x;
	var y = mouse_tile_pos.y;
	
	if x > 7 or x < 0:
		#print("x: ", x, " y: ", y)
		if $BuildCursor.get_child_count() > 0:
			var plant = $BuildCursor.get_child(0);
			plant.hide();
	elif y > 2 or y < 0:
		#print("x: ", x, " y: ", y)
		if $BuildCursor.get_child_count() > 0:
			var plant = $BuildCursor.get_child(0);
			plant.hide();
	elif is_cursor_plant_colliding():
		var plant = $BuildCursor.get_child(0);
		plant.show();
		if $BuildCursor.get_child_count() > 0:
			plant.get_node("Place").modulate = Color.RED;
			#$BuildCursor.get_child(0).hide();
	else:
		#print("x: ", x, " y: ", y)
		if $BuildCursor.get_child_count() > 0:
			var plant = $BuildCursor.get_child(0);
			plant.show();
			if plant.has_node("Place"):
				plant.get_node("Place").modulate = Color.WHITE;

	$BuildCursor.position = tile_pos * tile_size;
	
	if not paused:
		if is_level_done():
			_on_level_done();


func _on_level_done():
	paused = true;
	print("plantmap: level done");
	$Task_succeeded.play();
	emit_signal("level_done", current_level_index);


func remove_all_plants():
	var plants = $Plants.get_children();
	for plant in plants:
		plant.queue_free();

func update_level(new_index):
	paused = false;
	current_level_index = new_index;
	
	for i in range(current_level_index +1):
		var blocker_path = "Blocker" + str(i);
		if has_node(blocker_path):
			$Delete_blocker.play();
			get_node(blocker_path).deactivate();
	
	emit_signal("level_changed", current_level_index);
	
	
func get_new_plant(type) -> Plant:
	if not (plants_by_name.has(type)):
		print(type, "not in list");
		return
		
	var plant_scene = plants_by_name[type];

	var plant = plant_scene.instantiate();
	plant.type = type;
	return plant;

func create_plant(type, global_plant_position):
	
	timer.start(0.1);
	
	var new_plant = get_new_plant(type);
	if new_plant != null:
		new_plant.global_position = global_plant_position;

		plants_group.add_child(new_plant);
		new_plant._on_plant();


func get_plant_at_mouse() -> Plant:
	var plants = plants_group.get_children() as Array[Plant];
	for plant in plants:
		if plant.mouse_inside:
			return plant;
	return null;

func _on_cursor_mode_change(mode):
	var type = mode;
	
	# clear
	for child in $BuildCursor.get_children():
		$BuildCursor.remove_child(child);
			
	if plants_by_name.has(type):
		$BuildCursor.show();
		var new_plant = get_new_plant(type);
		var new_place = new_plant.get_node("Place");
		
		#new_place.get_parent().remove_child(new_place);
		$BuildCursor.add_child(new_plant);
		new_plant.get_node("AnimatedSprite2D").hide();
		new_place.show();
	else:
		$BuildCursor.hide();

func get_mouse_tile_pos():
	var local_mouse_pos = get_local_mouse_position();
	# 8 * 3
	
#	var map_width = 8 * tile_size;
#	var map_height = 3 * tile_size;
#	var scale_strength = local_mouse_pos.y;
	var vector = Vector2i(floor(local_mouse_pos / tile_size));
	#print(vector);
	return vector;
	
	
func is_cursor_plant_colliding() -> bool:
	if $BuildCursor.get_child_count() == 0:
		return false;
	
	var plant_in_cursor = $BuildCursor.get_child(0);
	if plant_in_cursor == null or not (plant_in_cursor is Area2D):
		return false;
	
	# is place here???
	var plant_collisions = plant_in_cursor.get_overlapping_areas();
	var mouse_pos = get_mouse_tile_pos();
	

	
	for collision in plant_collisions:
		if collision.is_in_group("plant") or collision.is_in_group("blocker"):
			return true;
			
	match plant_in_cursor.type:
		"Stan":
			if mouse_pos.x > 6:
				return true;
			elif mouse_pos.y > 1:
				return true;
		"Jeff":
			if mouse_pos.x > 5:
				return true;
		"Assi":
			if mouse_pos.x > 6:
				return true;
		"Frank":
			if mouse_pos.x > 5 or mouse_pos.y != 1:
				return true;
		"Toni":
			if mouse_pos.x > 5 or mouse_pos.y < 1:
				return true;

	return false;


func get_all_plants():
	return $Plants.get_children() as Array[Plant];


func get_grown_plant_count():
	var plant_count = {};
	var plants = get_all_plants();
	for plant in plants:
		if not plant_count.has(plant.type):
			plant_count[plant.type] = 0;
			
		if not plant.planted:
			continue;
		
		if plant.growth_state != plant.GrowthState.final:
			continue;

		if plant.growth_state == plant.GrowthState.infected:
			continue;
			
		plant_count[plant.type] += 1;
	#print(plant_count);
	return plant_count;


func get_current_level():
	return levels[current_level_index];

func is_two_of(type) -> bool:
	var compare = get_grown_plant_count();
	if compare.has(type):
		return compare[type] == 2;
	return false;

func is_one_of_each() -> bool:
	var active_plants = get_grown_plant_count();
	var active_level = get_current_level();
	var required_plants = active_level["required_plants"];
	
	if active_plants.is_empty():
		return false;
		
	for type in required_plants:
		if active_plants.has(type):
			if not active_plants[type] >= 1:
				return false;
		else:
			return false;
	
	return true;
	
func is_board_filled() -> bool:
	var active_plants = get_grown_plant_count();
	var buff = 0;

	for type in active_plants:
		buff += active_plants[type] * spaces[type];

	match current_level_index:
		0: 
			if buff == 3:
				return true;
		1:
			if buff == 6:
				return true;
		2:
			if buff == 9:
				return true;
		3:
			if buff == 13:
				return true;
		4:
			if buff == 19:
				return true;
		5:
			if buff == 24:
				return true;
	return false;
	

func is_level_done() -> bool:
	if timer.time_left:
		return false;
	
	var level = get_current_level();
	
	if level == null:
		return false;
		
	if level["requires_filled_board"] and is_board_filled() == false:
		return false;
		
	var counts = get_grown_plant_count();
	var plants = get_all_plants();
	
	for plant in plants:
		if not(plant.affected):
			return false;
	
	var required_counts = level["required_plants"];
	
	for type in required_counts:
		if not required_counts.has(type):
			continue;
		var required_plant_count = required_counts[type];
		if not counts.has(type):
			return false;
		if counts[type] < required_plant_count:
			return false;
	return true;

func _on_mouse_collider_input_event(_viewport, event, _shape_idx):
	if paused:
		return;
	
	if event is InputEventMouseButton and event.is_pressed():
		# var blocker = get_tree().get_nodes_in_group("blocker");
		
		
		var plant = get_plant_at_mouse();
		if plant != null:
			plant._handle_click(get_global_mouse_position());
			return;
			
		
		var tile_pos = get_mouse_tile_pos();
		var tile_id = $TileMap.get_cell_source_id(0, tile_pos);
		print("map click at", tile_pos);
		
		if (tile_id != -1):
			if is_cursor_plant_colliding():
				$SndError.play();
				print("can't place");
				return;
			
			if Game.cursor_mode == "default":
				return;
			
			$Plant_place.play();
			create_plant(Game.cursor_mode, tile_pos * tile_size);

