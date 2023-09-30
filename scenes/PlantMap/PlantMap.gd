extends TileMap

@onready var Plant = preload("res://scenes/Plant/Plant.tscn");
@onready var PlantBHi = preload("res://scenes/Plant/PlantBHi.tscn");
@onready var PlantAssi = preload("res://scenes/Plant/PlantAssi.tscn");
@onready var PlantFrank = preload("res://scenes/Plant/PlantFrank.tscn");
@onready var PlantJeff = preload("res://scenes/Plant/PlantJeff.tscn");
@onready var PlantStan = preload("res://scenes/Plant/PlantStan.tscn");
@onready var PlantToni = preload("res://scenes/Plant/PlantToni.tscn");

@onready var plants_by_name = {
	"BHi": PlantBHi,
	"Assi": PlantAssi,
	"Frank": PlantFrank,
	"Jeff": PlantJeff,
	"Stan": PlantStan,
	"Toni": PlantToni,
};

func create_plant(type, plant_position):
	if not (plants_by_name.has(type)):
		print(type, "not in list");
		return
		
	var plant_scene = plants_by_name[type];

	var new_plant: Node2D = plant_scene.instantiate();
	new_plant.global_position = plant_position;
	
	add_child(new_plant);

#func _process(delta):
#	if Input.is_action_just_pressed("click"):
#		var tile_pos = Vector2i(get_local_mouse_position() / 64);
#		var tile_id = get_cell_source_id(0, tile_pos);
#
#		if (tile_id != -1):
#			create_plant(Game.PlantType.A, tile_pos * 64);


func _on_mouse_collider_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		print("click handled on ", self);
		var tile_pos = Vector2i(get_local_mouse_position() / 64);
		print(tile_pos)
		var tile_id = get_cell_source_id(0, tile_pos);
		
		if (tile_id != -1):
			create_plant(Game.cursor_mode, tile_pos * 64);
