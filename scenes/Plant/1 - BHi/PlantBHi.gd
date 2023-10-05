extends "res://scenes/Plant/Plant.gd"

var affected = false;

func _ready():
	super._ready();
	grow_speed = 5;
	buff_amount = 2;


func _on_plant():
	await super._on_plant();

	# handle effects to self first
	var affecting_plants = await get_all_affecting_plants();
	print("affecting_plants", affecting_plants);
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
	# BHi can infect others if infected
	if is_neutralized():
		return;
		
	if growth_state == GrowthState.infected:
		if plant.type == "BHi":
			$Infect.play();
			plant.change_to_state(GrowthState.infected);
	
	# BHi does not affect anything
	return;

func _on_state_change(new_state, _old_state):
	# When we become infected, infect all other BHis
	if new_state == GrowthState.infected:
		var plants = await get_all_neighbour_plants();
		for plant in plants:
			affect_plant(plant);
