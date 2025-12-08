extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	get_tree().paused = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		visible = true
		get_tree().paused = true

func _on_resumebutton_pressed() -> void:
	visible = false
	get_tree().paused = false

func _on_optionsbutton_pressed() -> void:
	print("settings pressed")

func _on_main_menubutton_pressed() -> void:
	visible = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
