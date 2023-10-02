extends Node2D

@onready var menu = $Menu;
@onready var default_menu_y = menu.position.y;

func _ready():
	
	menu.position.y = default_menu_y + 50;
	
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
	
	# enable plants
	if level_index >= 1:
		$Menu/PlantButtonStan.enable();
	if level_index >= 2:
		$Menu/PlantButtonJeff.enable();
	if level_index >= 3:
		$Menu/PlantButtonAssi.enable();
	if level_index >= 4:
		$Menu/PlantButtonFrank.enable();
	if level_index >= 5:
		$Menu/PlantButtonToni.enable();



func _on_plant_map_level_done(level_index):
	print("main: level done", level_index);
	await fade_out_menu();
	
	$PlantMap.remove_all_plants();
	
	await Game.wait(0.5);
	
	await show_level_intro(level_index + 1);
	
	await $PlantMap.update_level(level_index + 1);
	
	await fade_in_menu();


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


func fade_out_menu():
	var tween = get_tree().create_tween();
	tween.tween_property(menu, "position:y", default_menu_y + 50, 1);
	tween.set_ease(Tween.EASE_IN);
	await tween.finished;

func fade_in_menu():
	var tween = get_tree().create_tween();
	tween.tween_property(menu, "position:y", default_menu_y, 1);
	tween.set_ease(Tween.EASE_OUT);
	await tween.finished;
