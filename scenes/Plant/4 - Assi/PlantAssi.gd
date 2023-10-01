extends "res://scenes/Plant/Plant.gd"

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
		return;

	for plant in plants:
		if plant == self:
			continue;
		affect_plant(plant);


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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
