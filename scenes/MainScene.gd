extends Node2D

@onready var menu = $Menu;
@onready var default_menu_y = menu.position.y;

@onready var task_panel = $Tasks;
@onready var task_container = $Tasks/VBoxContainer;



func _ready():
	MusicPlayer.fade_to("radio");
	Game.init_vars();
	task_panel.hide();
	menu.position.y = default_menu_y + 50;
	
	$Menu/PlantButtonStan.disable();
	$Menu/PlantButtonJeff.disable();
	$Menu/PlantButtonAssi.disable();
	$Menu/PlantButtonFrank.disable();
	$Menu/PlantButtonToni.disable();
	
func _process(_delta):
#	if $CursorImage.visible == true:
#		$CursorImage.global_position = get_global_mouse_position();
	update_tasks_status();

func _on_plant_map_level_changed(level_index):
	
	$LevelIndex.text = "Level: " + str(level_index + 1);
	
	task_panel.show();
	var tasks = task_container.get_children();
	for task in tasks:
		task.get_node("CheckBox").button_pressed = false;
		task.hide();
	
	# show task
	match level_index:
		0:
			task_container.get_node("FillTheBoard").show();
		1:
			task_container.get_node("FillTheBoard").show();
			task_container.get_node("OneOfEach").show();
		2:
			task_container.get_node("OneOfEach").show();
			task_container.get_node("TwoPurple").show();
		3:
			task_container.get_node("OneOfEach").show();
		4:
			task_container.get_node("OneOfEach").show();
			task_container.get_node("TwoRed").show();
		5:
			task_container.get_node("OneOfEach").show();
			task_container.get_node("FillTheBoard").show();
	
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


func update_tasks_status():
	if task_panel.visible == false:
		return;
	
	var tasks = task_container.get_children();
	for task in tasks:
		if task.visible == false:
			continue;
		
		var task_fulfilled = false;
		
		match task.name:
			"OneOfEach":
				task_fulfilled = $PlantMap.is_one_of_each();
			"FillTheBoard":
				task_fulfilled = $PlantMap.is_board_filled();
			"TwoPurple":
				task_fulfilled = $PlantMap.is_two_of("BHi");
			"TwoRed":
				task_fulfilled = $PlantMap.is_two_of("Stan");
		
		task.get_node("CheckBox").button_pressed = task_fulfilled;

func _on_plant_map_level_done(level_index):
	print("main: level done", level_index);
	await fade_out_menu();
	
	$PlantMap.remove_all_plants();
	
	task_panel.hide();
	
	await Game.wait(0.5);
	
	await show_level_intro(level_index + 1);
	
	if level_index +1 == 6:
		SceneManager.change_scene("res://screens/CreditsScene.tscn");
	
	else:
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
		2:
			await DialogOverlay.do_dialog([
				{
					"actor": "prof",
					"type": "line",
					"lines": [
						"No problem at all!",
						"What did you try to do again?"
					]
				},
				{
					"actor": "chef",
					"type": "line",
					"lines": [
						"THOSE were the easy ones. The next is much more tricky."
					]
				},
				{
					"actor": "prof",
					"type": "line",
					"lines": [
						"And much more icky, too!",
						"What is that?"
					]
				}
			], self);
		3:
			if Game.found_infection:
				await DialogOverlay.do_dialog([
					{
						"actor": "prof",
						"type": "line",
						"lines": [
							"That was unexpected! Looks like a super-spreading fungus!"
						]
					},
					{
						"actor": "prof",
						"type": "line",
						"lines": [
							"It only seems to affect one of the plants though.",
							"I'll have to see how it reacts to others..."
						]
					},
					{
						"actor": "prof",
						"type": "line",
						"lines": [
							"What's next?"
						]
					}
				], self);
			else:
				await DialogOverlay.do_dialog([
					{
						"actor": "prof",
						"type": "line",
						"lines": [
							"Okay... that was easy too. What is the deal?"
						]
					},
					{
						"actor": "chef",
						"type": "line",
						"lines": [
							"I don't understand... It did something when I planted it."
						]
					},
					{
						"actor": "chef",
						"type": "line",
						"lines": [
							"You must have done it right the first time!"
						]
					},
					{
						"actor": "prof",
						"type": "line",
						"lines": [
							"Great! That's how I work.",
							"What's next?"
						]
					}
				], self);
			await DialogOverlay.do_dialog([
				{
					"actor": "chef",
					"type": "line",
					"lines": [
						"Don't touch that directly!",
						"That one is troublesome."
					]
				}
			], self);
		4:
			await DialogOverlay.do_dialog([
				{
					"actor": "prof",
					"type": "line",
					"lines": [
						"Great. This is interesting now."
					]
				},
				{
					"actor": "chef",
					"type": "line",
					"lines": [
						"Okay, but this one is BIG.",
						"How are you going to handle that?"
					]
				}
			], self);
		5:
			await DialogOverlay.do_dialog([
				{
					"actor": "prof",
					"type": "line",
					"lines": [
						"I'm great, am I not?"
					]
				},
				{
					"actor": "chef",
					"type": "line",
					"lines": [
						"..."
					]
				},
				{
					"actor": "chef",
					"type": "line",
					"lines": [
						"Don't get too cocky, Jeff."
					]
				}
			], self);
		6:
			await DialogOverlay.do_dialog([
				{
					"actor": "prof",
					"type": "line",
					"lines": [
						"Nice warmup! What now?"
					]
				},
				{
					"actor": "chef",
					"type": "line",
					"lines": [
						"That's...",
						"...",
						"... it."
					]
				},
				{
					"actor": "prof",
					"type": "line",
					"lines": [
						"What?"
					]
				},
				{
					"actor": "chef",
					"type": "line",
					"lines": [
						"You're done! Congratulations, Jeff, you proved it again."
					]
				},
				{
					"actor": "prof",
					"type": "line",
					"lines": [
						"Oh!",
						"Great.",
						"Well, you know where to find me."
					]
				},
				{
					"actor": "chef",
					"type": "line",
					"lines": [
						"...",
						"Every time."
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
	$Console_up.play();
	tween.tween_property(menu, "position:y", default_menu_y, 1);
	tween.set_ease(Tween.EASE_OUT);
	await tween.finished;


func _on_space_station_finished():
	$SpaceStation.play(0); # Replace with function body.
