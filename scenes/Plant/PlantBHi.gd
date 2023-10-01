extends "res://scenes/Plant/Plant.gd"

func _ready():
	super._ready();
	grow_speed = 5;
	buff_amount = 2;

func _on_plant():
	super._on_plant();
	pass
