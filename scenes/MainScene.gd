extends Node2D

func _ready():
	Game.connect("cursor_mode_changed", _on_cursor_mode_changed);
	
	$Menu/PlantButtonStan.disable();
	$Menu/PlantButtonJeff.disable();
	$Menu/PlantButtonAssi.disable();
	$Menu/PlantButtonFrank.disable();
	$Menu/PlantButtonToni.disable();
	
func _process(delta):
#	if $CursorImage.visible == true:
#		$CursorImage.global_position = get_global_mouse_position();
	pass

func _on_plant_map_level_changed(level_index):
	$LevelIndex.text = "Level: " + str(level_index + 1);
	
	await show_level_intro(level_index);
	
	# enable plants
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
#	var node_path = "Menu/PlantButton" + mode + "/AnimatedSprite2D";
#	if has_node(node_path):
#		var sprite = get_node(node_path);
#		$CursorImage.sprite_frames = sprite.sprite_frames;
#		$CursorImage.show();
#		$CursorImage.play();
#
#	else:
#		$CursorImage.hide();
	pass

func show_level_intro(level_index):
	match level_index:
		0:
			await DialogOverlay.do_dialog([
				{
					"actor": "chef",
					"type": "line",
					"lines": [
						"Professor Jeff!",
						"We're counting on you!",
						"We've got a fresh shipment of plants from CR708."
					]
				},
				{
					"actor": "prof",
					"type": "line",
					"lines": [
						"Great! I'm on my way. What do they do?"
					]
				},
				{
					"actor": "chef",
					"type": "line",
					"lines": [
						"Thats the thing.",
						"We don't know.",
						"We don't even get to plant them all at once!",
					]
				},
				{
					"actor": "chef",
					"type": "line",
					"lines": [
						"They keep canibalizing each other!",
					]
				},
				{
					"actor": "prof",
					"type": "line",
					"lines": [
						"Strange.",
						"Did you try pulling them out and putting them in again?"
					]
				},
				{
					"actor": "chef",
					"type": "line",
					"lines": [
						"Well, that's YOUR job now.",
						"Plant them all!"
					]
				},
				{
					"actor": "prof",
					"type": "line",
					"lines": [
						"Okaydokay.",
						"Let's better start slow..."
					]
				},
			],
			self);
		1:
			await DialogOverlay.do_dialog([
				{
					"actor": "prof",
					"type": "line",
					"lines": [
						"Seems like this plant grows nicely if it's alone."
					]
				},
				{
					"actor": "chef",
					"type": "line",
					"lines": [
						"We knew that already.",
						"The problems start with more plants!"
					]
				},
				{
					"actor": "prof",
					"type": "line",
					"lines": [
						"Let's tackle that, then."
					]
				}
			], self);
