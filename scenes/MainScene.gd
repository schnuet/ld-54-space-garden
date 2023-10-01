extends Node2D

func _ready():
	Game.connect("cursor_mode_changed", _on_cursor_mode_changed);
	
	$Menu/PlantButtonStan.disable();
	$Menu/PlantButtonJeff.disable();
	$Menu/PlantButtonAssi.disable();
	$Menu/PlantButtonFrank.disable();
	$Menu/PlantButtonToni.disable();
	
func _process(delta):
	if $CursorImage.visible == true:
		$CursorImage.global_position = get_global_mouse_position();

func _on_plant_map_level_changed(level_index):
	$LevelIndex.text = "Level: " + str(level_index + 1);
	
	if level_index == 1:
		$Menu/PlantButtonStan.enable();
		$Menu/PlantButtonJeff.enable();
	if level_index == 2:
		$Menu/PlantButtonAssi.enable();
	if level_index == 3:
		$Menu/PlantButtonFrank.enable();
	if level_index == 4:
		$Menu/PlantButtonToni.enable();

func _on_cursor_mode_changed(mode):
	var node_path = "Menu/PlantButton" + mode + "/AnimatedSprite2D";
	if has_node(node_path):
		var sprite = get_node(node_path);
		$CursorImage.sprite_frames = sprite.sprite_frames;
		$CursorImage.show();
		$CursorImage.play();
	
	else:
		$CursorImage.hide();
