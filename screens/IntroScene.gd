extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var lines = [
		{
			"type": "line",
			"style": "normal", 
			"lines": [
				"So... ",
				"welcome to Stork inc., old pal!"
			]
		},
		{
			"type": "action", 
			"action": turn_on_light,
		},
		{
			"type": "line",
			"style": "normal", 
			"lines": [
				"Let's start!"
			]
		},
	];
	await DialogOverlay.do_dialog(lines);
	
	start_game();


func turn_on_light():
	print("turn_on_lights")
	

func start_game():
	# Set all game variables
	
	SceneManager.change_scene("res://scenes/MainScene.tscn");

func _on_skip_button_pressed():
	start_game();
