extends "res://scenes/Plant/Plant.gd"

func _ready():
	super._ready();
	grow_speed = 5;
	buff_amount = 2;


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
	# BHi can infect others if infected
	if is_neutralized():
		return;
		
	if growth_state == GrowthState.infected:
		if plant.type == "BHi":
			plant.change_to_state(GrowthState.infected);
	
	# BHi does not affect anything
	return;

func _on_state_change(new_state, old_state):
	# When we become infected, infect all other BHis
	if new_state == GrowthState.infected:
		var plants = await get_all_neighbour_plants();
		for plant in plants:
			affect_plant(plant);
