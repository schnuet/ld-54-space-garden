extends "res://scenes/Plant/Plant.gd"

func _ready():
	super._ready();
	grow_speed = 10;

func _on_plant():
	super._on_plant();
	
	var plants = get_all_neighbour_plants();
	
	for plant in plants:
		match plant.type:
			"BHi":
				plant.kill();
			"Stan":
				plant.kill();
			"Jeff":
				plant.kill();
			"Toni":
				plant.buff();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
