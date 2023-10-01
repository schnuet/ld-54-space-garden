extends Sprite2D

@export var width = 1280;
@export var speed = 10.0;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x -= delta * speed;
	
	if position.x < -1280:
		position.x = 1280;
