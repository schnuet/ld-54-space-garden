extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D;

func deactivate():
	animated_sprite.play();
	await animated_sprite.animation_finished;
	queue_free();
