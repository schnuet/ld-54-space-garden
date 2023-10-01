class_name PlantMap
extends TileMap

# 4*6
signal level_changed(level_index);

@onready var plants_group:Node2D = $Plants;

@onready var Plant = preload("res://scenes/Plant/Plant.tscn");
@onready var PlantBHi = preload("res://scenes/Plant/1 - BHi/PlantBHi.tscn");
@onready var PlantStan = preload("res://scenes/Plant/2 - Stan/PlantStan.tscn");
@onready var PlantJeff = preload("res://scenes/Plant/3 - Jeff/PlantJeff.tscn");
@onready var PlantAssi = preload("res://scenes/Plant/4 - Assi/PlantAssi.tscn");
@onready var PlantFrank = preload("res://scenes/Plant/5 - Frank/PlantFrank.tscn");
@onready var PlantToni = preload("res://scenes/Plant/6 - Toni/PlantToni.tscn");

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
		"required_plants": {
			"BHi": 3
		}
	},
	{
		"required_plants": {
			"BHi": 2,
			"Stan": 1,
			"Jeff": 1
		}
	},
	{
		"required_plants": {
			"BHi": 1,
			"Stan": 1,
			"Jeff": 1,
			"Assi": 1
		}
	},
	{
		"required_plants": {
			"BHi": 1,
			"Stan": 2,
			"Jeff": 1,
			"Assi": 1,
			"Frank": 1
		}
	},
	{
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
var current_level_index = 0;

func _ready():
	emit_signal("level_changed", 0);
	
	Game.connect("cursor_mode_changed", _on_cursor_mode_change);

func _process(delta):
	# position build cursor
	var mouse_tile_pos = get_mouse_tile_pos();
	var tile_pos = Vector2i(
		clamp(mouse_tile_pos.x, 0, 17),
		clamp(mouse_tile_pos.y, 0, 11)
	);
	$BuildCursor.position = tile_pos * tile_size;
	
	if is_level_done():
		_on_level_done();


func _on_level_done():
	current_level_index += 1;
	emit_signal("level_changed", current_level_index);
	get_node("Blocker" + str(current_level_index)).queue_free();
	
	
func get_new_plant(type) -> Plant:
	if not (plants_by_name.has(type)):
		print(type, "not in list");
		return
		
	var plant_scene = plants_by_name[type];

	var plant = plant_scene.instantiate();
	plant.type = type;
	return plant;

func create_plant(type, global_plant_position):
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
		$BuildCursor.add_child(new_plant);
	else:
		$BuildCursor.hide();

func get_mouse_tile_pos():
	var local_mouse_pos = get_local_mouse_position();
	# 8 * 3
	
#	var map_width = 8 * tile_size;
#	var map_height = 3 * tile_size;
#	var scale_strength = local_mouse_pos.y;
	
	return Vector2i(local_mouse_pos / tile_size);
	
	
func is_cursor_plant_colliding() -> bool:
	var plant_in_cursor = $BuildCursor.get_child(0);
	if plant_in_cursor == null or not (plant_in_cursor is Plant):
		print("no plant in cursor");
		return false;
	
	# is place here???
	var plant_collisions = plant_in_cursor.get_overlapping_areas();
	for collision in plant_collisions:
		if collision.is_in_group("plant"):
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

		plant_count[plant.type] += 1;
	
	return plant_count;


func get_current_level():
	return levels[current_level_index];


func is_level_done():
	var level = get_current_level();
	
	if level == null:
		return;
	
	var counts = get_grown_plant_count();
	
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


func _on_mouse_collider_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		
		var blocker = get_tree().get_nodes_in_group("blocker");
		
		
		var plant = get_plant_at_mouse();
		if plant != null:
			plant._handle_click(get_global_mouse_position());
			return;
			
		
		var tile_pos = get_mouse_tile_pos();
		var tile_id = get_cell_source_id(0, tile_pos);
		print("map click at", tile_pos);
		
		if (tile_id != -1):
			if is_cursor_plant_colliding():
				return;
			
			create_plant(Game.cursor_mode, tile_pos * tile_size);
