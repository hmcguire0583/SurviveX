extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioController.play_menu_music()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	GameManager.game_reset()
	get_tree().change_scene_to_file("res://scenes/world.tscn")
	AudioController.stop_menu_music()

func _on_optionsbutton_pressed() -> void:
	$volumepanel.visible = true
	$menulabel.visible = false
	$VBoxContainer.visible = false


func _on_instructionsbutton_pressed() -> void:
	pass # Replace with function body.
	
func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_backbutton_pressed() -> void:
	$volumepanel.visible = false
	$menulabel.visible = true
	$VBoxContainer.visible = true


func _on_volumeslider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)
