extends Node

var enemies_defeated := 0
var challenge_active := false
var current_island : int = 0
var islands_unlocked : int = 0
var current_day := 1
var time = "day"
var nightvision = false
var unlocked_islands = {
	0: true
}
const TOTAL_ENEMIES := 30

func add_enemy_defeated():
	enemies_defeated += 2
	print("Enemies defeated: %d" % enemies_defeated)

	if enemies_defeated >= TOTAL_ENEMIES:
		trigger_victory()

func trigger_victory():
	print("All 30 zombies defeated! Victory!")
	# Example: change to victory scene or main menu
	get_tree().change_scene_to_file("res://scenes/GameWinner.tscn")
	
func game_reset():
	enemies_defeated = 0
	challenge_active = false
	current_island = 0
	islands_unlocked = 0
	current_day = 1
	time = "day"
	nightvision = false
	unlocked_islands = {0: true}

	print("Game has been reset!")
	# Example: return to main menu or restart scene
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
