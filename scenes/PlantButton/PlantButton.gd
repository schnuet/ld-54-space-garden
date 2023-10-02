extends Area2D

@export var plant_type: String = "";

var custom_speed = 1.0;
var disabled = false;

func _ready():
	custom_speed += randf() * 0.2 - 0.1;
	
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.play("default", custom_speed);
		$AnimatedSprite2D.frame = randi_range(0, 16);
	
	connect("mouse_entered", _on_mouse_enter);
	connect("mouse_exited", _on_mouse_exit);

func _on_input_event(_viewport, event, _shape_idx):
	if disabled:
		return;
		
	# CLICK HANDLER!
	if event is InputEventMouseButton and event.is_pressed():
		get_viewport().set_input_as_handled();
		$Button_push.play();
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
		
func disable():
	disabled = true;
	modulate = Color(0, 0, 0, 0.4);

func enable():
	disabled = false;
	modulate = Color.WHITE;
