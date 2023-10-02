extends Node2D

@onready var logo = $SpaceGardenLogoFinal;
@onready var color_rect = $ColorRect;

# Called when the node enters the scene tree for the first time.
func _ready():
	color_rect.show();
	MusicPlayer.play_music("main");
	logo.modulate = Color.TRANSPARENT;
	
	var timer = get_tree().create_timer(1);
	await timer.timeout;
	fade_in_logo();
#	timer.connect("timeout", fade_in_logo);
	var tween = get_tree().create_tween().tween_property(color_rect, "modulate", Color.TRANSPARENT, 2);
	await tween.finished;
	
	$StartButton.show();
	$CreditsButton.show();

func _process(_delta):
	var max_frame = 7;
	var f = min(max_frame, Game.anim_frame);
	
	$AnimatedSprite2D.frame = f;
	
func fade_in_logo():
	var tween = create_tween().tween_property(logo, "modulate", Color.WHITE, 2);
	await tween.finished;

func _on_start_button_pressed():
	SceneManager.change_scene("res://scenes/MainScene.tscn");


func _on_credits_button_pressed():
	SceneManager.change_scene("res://screens/CreditsScene.tscn");
