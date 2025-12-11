extends CanvasLayer

func _ready() -> void:
	visible = false
	get_tree().paused = false

	# Correct path: instructionpanel2 is sibling of VBoxContainer
	var instructions_text_node = $instructionpanel2/instructionsText2
	instructions_text_node.editable = false
	instructions_text_node.focus_mode = Control.FOCUS_NONE

	# Hide panels at start
	$instructionpanel2.visible = false
	$volumepanel.visible = false

	# Make sure instructions panel draws above background
	$instructionpanel2.z_index = 1

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
	$instructionpanel2.visible = false
	$VBoxContainer.visible = false
	$pauselabel.visible = false

func _on_instructionsbutton_pressed() -> void:
	print("Instructions button pressed")  # Debug
	$instructionpanel2.visible = true
	$volumepanel.visible = false
	$VBoxContainer.visible = false
	$pauselabel.visible = false
	print("instructionpanel2 visibility:", $instructionpanel2.visible)

func _on_backbutton_pressed() -> void:
	$volumepanel.visible = false
	$instructionpanel2.visible = false
	$VBoxContainer.visible = true
	$pauselabel.visible = true

func _on_backbutton_3_pressed() -> void:
	$instructionpanel2.visible = false
	$VBoxContainer.visible = true
	$pauselabel.visible = true
	

func _on_main_menubutton_pressed() -> void:
	visible = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_volumeslider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)
