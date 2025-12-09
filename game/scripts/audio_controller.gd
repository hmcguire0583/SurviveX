extends Node

@onready var menu_music: AudioStreamPlayer = $menu_music


func play_menu_music():
	menu_music.play()
	
func stop_menu_music():
	menu_music.stop()
