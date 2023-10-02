extends "res://scenes/Plant/Plant.gd"

var height = 1;
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
	if is_neutralized():
		return;

	match plant.type:
		"BHi":
			plant.change_to_state(GrowthState.infected);
		"Toni":
			plant.neutralize();
