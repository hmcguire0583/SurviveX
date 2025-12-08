extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioController.play_menu_music()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")
	AudioController.stop_menu_music()


func _on_settings_pressed() -> void:
	print("settings pressed")



func _on_exit_pressed() -> void:
	get_tree().quit()
