extends "res://scenes/Plant/Plant.gd"

var height = 2;
var width = 3;

func _ready():
	super._ready();
	grow_speed = 10;

func _on_plant():
	super._on_plant();
	
	var plants = await get_all_neighbour_plants();
	
	# handle effects to self first
	for plant in plants:
		if plant == self:
			continue;
		plant.affect_plant(self);

	if is_neutralized():
		return;

	for plant in plants:
		if plant == self:
			continue;
		affect_plant(plant);

func affect_plant(plant: Plant):
	print(type, " affect ", plant.type);
	
	if is_neutralized():
		return;
		
	if plant.type == self.type:
		plant.buff();
		
func reaffect_plant(plant: Plant):
	print(type, " REaffect ", plant.type);
	
	if is_neutralized():
		return;
	
	if plant.type == self.type:
		plant.nerf();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
