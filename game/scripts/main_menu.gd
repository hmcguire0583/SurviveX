extends Control

func _ready() -> void:
	AudioController.play_menu_music()
	$volumepanel.visible = false
	$instructionpanel.visible = false
	# Disable editing on instructionsText so it's read-only
	$instructionpanel/instructionsText.editable = false
	$instructionpanel/instructionsText.focus_mode = Control.FOCUS_NONE

func _process(delta: float) -> void:
	pass

func _on_start_pressed() -> void:
	GameManager.game_reset()
	get_tree().change_scene_to_file("res://scenes/world.tscn")
	AudioController.stop_menu_music()

func _on_optionsbutton_pressed() -> void:
	$volumepanel.visible = true
	$instructionpanel.visible = false
	$menulabel.visible = false
	$VBoxContainer.visible = false

func _on_instructionsbutton_pressed() -> void:
	$instructionpanel.visible = true
	$volumepanel.visible = false
	$menulabel.visible = false
	$VBoxContainer.visible = false

func _on_exit_pressed() -> void:
	if OS.has_feature("web"):
		JavaScriptBridge.eval("window.location.href = '/'")
	else:
		get_tree().quit()



func _on_backbutton_pressed() -> void:
	$volumepanel.visible = false
	$instructionpanel.visible = false
	$menulabel.visible = true
	$VBoxContainer.visible = true

func _on_backbutton2_pressed() -> void:
	$instructionpanel.visible = false
	$menulabel.visible = true
	$VBoxContainer.visible = true

func _on_volumeslider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)
