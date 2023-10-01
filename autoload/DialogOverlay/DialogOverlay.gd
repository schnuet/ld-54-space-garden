extends Control

var timer = null;
var tween = null;

@onready var portrait = $Portrait;
@onready var speech_box = $Speech;
@onready var panel = $Panel;


func do_dialog(lines: Array):
	panel.show();
	speech_box.show();
	
	for line in lines:
		if line.get("type") == "line":
			await update_speech(line);
		elif line.get("type") == "action":
			await line.get("action").call();
	
	panel.hide();
	speech_box.hide();

func update_speech(line):
	var texts = line.get("lines");
	speech_box.visible_characters = 0;
	speech_box.text = "";
	
	if line.get("style") == "scream":
		portrait.animation = "scream";
		speech_box.uppercase = true;
	else:
		portrait.animation = "normal";
		speech_box.uppercase = false;
	
	for text in texts:
		print("next line!");
		var new_text_length = len(text);
		var old_text_length = len(speech_box.text);
		var text_length = old_text_length + new_text_length;
		speech_box.text += text;
		tween = await get_tree().create_tween();
		tween.tween_property(speech_box, "visible_characters", text_length, new_text_length * 0.03).from(old_text_length);
		await tween.finished;
		speech_box.visible_characters = text_length;
		timer = get_tree().create_timer(0.3)
		await timer.timeout
	
	timer = get_tree().create_timer(len(speech_box.text) * 0.2);
	await timer.timeout


func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if timer != null and timer.time_left > 0:
			timer.time_left = 0.0001;
		elif tween != null and tween.is_running():
			tween.stop();
			tween.emit_signal("finished");
