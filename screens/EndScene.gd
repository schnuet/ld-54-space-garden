extends Node2D

var success_lines = [
	{
		"type": "line",
		"style": "normal",
		"lines": [
			"Well, well, well! ",
			"Just been away for a little while and you bring the coins in!"
		]
	},
	{
		"type": "line",
		"style": "scream",
		"lines": [
			"That's my grandchild! You're the best!"
		]
	}
];

var average_lines = [
	{
		"type": "line",
		"style": "normal",
		"lines": [
			"Hello, my dear grandchild! ",
			"How did you do this week? "
		]
	},
	{
		"type": "line",
		"style": "normal",
		"lines": [
			"Oh! ",
			"Well, that's not bad. ",
			"Not fantastic either, but not bad."
		]
	}
];

var failure_lines = [
	{
		"type": "line",
		"style": "scream",
		"lines": [
			"What is this??!"
		]
	},
	{
		"type": "line",
		"style": "scream",
		"lines": [
			"How did that happen??",
			"I've only been away for a week!"
		]
	}
];

# Called when the node enters the scene tree for the first time.
func _ready():
	var lines_to_say = failure_lines;
	await DialogOverlay.do_dialog(lines_to_say);
	
	end_game();


func end_game():
	SceneManager.change_scene("res://screens/CreditsScene.tscn");

