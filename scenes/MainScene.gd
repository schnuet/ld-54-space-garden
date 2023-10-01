extends Node2D


func _on_plant_map_level_changed(level_index):
	$LevelIndex.text = "Level: " + str(level_index + 1);
