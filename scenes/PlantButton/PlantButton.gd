extends Area2D

@export var plant_type: String = "";

var custom_speed = 1.0;

func _ready():
	custom_speed += randf() * 0.2 - 0.1;
	
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.play("default", custom_speed);
		$AnimatedSprite2D.frame = randi_range(0, 16);
	
	connect("mouse_entered", _on_mouse_enter);
	connect("mouse_exited", _on_mouse_exit);

func _on_input_event(viewport, event, shape_idx):
	# CLICK HANDLER!
	if event is InputEventMouseButton and event.is_pressed():
		get_viewport().set_input_as_handled();
		Game.set_cursor_mode(plant_type);

func _on_mouse_enter():
	if has_node("AnimatedSprite2D"):
		var f = $AnimatedSprite2D.frame;
		$AnimatedSprite2D.animation = "hover";
		$AnimatedSprite2D.frame = f;
		

func _on_mouse_exit():
	if has_node("AnimatedSprite2D"):
		var f = $AnimatedSprite2D.frame;
		$AnimatedSprite2D.animation = "default";
		$AnimatedSprite2D.speed_scale = custom_speed;
		$AnimatedSprite2D.frame = f;
		
