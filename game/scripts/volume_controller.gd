extends CanvasLayer

func _ready() -> void:
	visible = false
	AudioController.play_menu_music()
	

func _on_volumeslider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)
	
func _process(delta: float) -> void:
	pass
	
func open_options():
	visible = true
	
func close_options():
	visible = false
