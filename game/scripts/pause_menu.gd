extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	get_tree().paused = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func open_pause():
	AudioController.play_menu_music()
	visible = true
	get_tree().paused = true

func _on_resumebutton_pressed() -> void:
	visible = false
	get_tree().paused = false
	AudioController.stop_menu_music()

func _on_optionsbutton_pressed() -> void:
	$volumepanel.visible = true
	$pauselabel.visible = false
	$VBoxContainer.visible = false

func _on_main_menubutton_pressed() -> void:
	visible = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_backbutton_pressed() -> void:
	$volumepanel.visible = false
	$pauselabel.visible = true
	$VBoxContainer.visible = true


func _on_volumeslider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)
