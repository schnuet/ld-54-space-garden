extends "res://scenes/Plant/Plant.gd"

var affected = false;

func _ready():
	super._ready();
	grow_speed = 10;

func _on_plant():
	await super._on_plant();
	
	# handle effects to self first
	var affecting_plants = await get_all_affecting_plants();
	for plant in affecting_plants:
		if plant == self:
			continue;
		plant.affect_plant(self);

	if is_neutralized():
		affected = true;
		return;

	var plants = await get_all_neighbour_plants();
	for plant in plants:
		if plant == self:
			continue;
		affect_plant(plant);
		
	affected = true;

func affect_plant(plant: Plant):
	print(type, " affect ", plant.type);
	
	if plant.type == "Assi":
		plant.neutralize();
	
	if is_neutralized():
		return;
