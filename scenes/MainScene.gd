extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_plant_map_level_changed(level_index):
	$LevelIndex.text = "Level: " + str(level_index + 1);
