extends Node

var enemies_defeated := 0
var challenge_active := false
var current_island : int = 0
var islands_unlocked : int = 0
var current_day := 1
var time = "day"
var unlocked_islands = { 0: true }

const TOTAL_ENEMIES := 30

func add_enemy_defeated():
	enemies_defeated += 1
	print("Enemies defeated: %d" % enemies_defeated)

	if enemies_defeated >= TOTAL_ENEMIES:
		trigger_victory()

func trigger_victory():
	print("All 30 zombies defeated! Victory!")
	# Example: change to victory scene or main menu
	get_tree().change_scene_to_file("res://scenes/GameWinner.tscn")
