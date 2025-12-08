extends CanvasLayer

@onready var label := $Label
@onready var timer := $AutoHideTimer

func _ready():
	label.visible = true
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	if label.text == "You Win!":
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	else:
		queue_free()
