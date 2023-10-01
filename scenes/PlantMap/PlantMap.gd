class_name PlantMap
extends TileMap

# 4*6

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

func _ready():
	Game.connect("cursor_mode_changed", _on_cursor_mode_change);

func _process(delta):
	# position build cursor
	var mouse_tile_pos = get_mouse_tile_pos();
	var tile_pos = Vector2i(
		clamp(mouse_tile_pos.x, 0, 17),
		clamp(mouse_tile_pos.y, 0, 11)
	);
	$BuildCursor.position = tile_pos * 64;
	
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

#func _process(delta):
#	if Input.is_action_just_pressed("click"):
#		var tile_pos = Vector2i(get_local_mouse_position() / 64);
#		var tile_id = get_cell_source_id(0, tile_pos);
#
#		if (tile_id != -1):
#			create_plant(Game.PlantType.A, tile_pos * 64);

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
	return Vector2i(get_local_mouse_position() / 64);
	
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

func _on_mouse_collider_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		var plant = get_plant_at_mouse();
		if plant != null:
			plant._handle_click(get_global_mouse_position());
			return;
		
		var tile_pos = get_mouse_tile_pos();
		var tile_id = get_cell_source_id(0, tile_pos);
		
		if (tile_id != -1):
			if is_cursor_plant_colliding():
				return;
			
			create_plant(Game.cursor_mode, tile_pos * 64);
