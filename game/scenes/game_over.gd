extends Control

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)

	# Wait 3 seconds, then go back to main menu
	var t = get_tree().create_timer(3.0)
	t.timeout.connect(func():
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	)
