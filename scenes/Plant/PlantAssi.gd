extends "res://scenes/Plant/Plant.gd"


func _on_plant():
	await get_tree().physics_frame;
	
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


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
