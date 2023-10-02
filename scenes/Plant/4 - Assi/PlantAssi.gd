extends "res://scenes/Plant/Plant.gd"

var affected = false;

func _ready():
	super._ready();
	grow_speed = 10;

func _on_plant():
	super._on_plant();
	
	var plants = await get_all_neighbour_plants();
	
	print(plants);
	
	# handle effects to self first
	for plant in plants:
		if plant == self:
			continue;
		plant.affect_plant(self);

	if is_neutralized():
		print("NEUTRALIZED");
		affected = true;
		return;

	for plant in plants:
		if plant == self:
			continue;
		affect_plant(plant);
		
	affected = true;


func affect_plant(plant: Plant):
	print(type, " affect ", plant.type);
	
	if is_neutralized():
		return;
		
	match plant.type:
		"BHi":
			plant.kill();
		"Stan":
			plant.kill();
		"Jeff":
			plant.kill();
		"Toni":
			plant.kill();
