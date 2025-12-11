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

var shark_scene = preload("res://scenes/smartshark.tscn")

# --- Shared Raft Health ---
var raft_max_health := 100
var raft_current_health := 100

signal raft_health_updated(new_health: int)
signal raft_damage_taken(amount: int)

func queue_shark_respawn(spawn_position: Vector2):
	var t = get_tree().create_timer(2.0)
	t.timeout.connect(func():
		if get_tree().current_scene:
			var new_shark = shark_scene.instantiate()
			new_shark.visible = true
			new_shark.spawn_position = spawn_position
			new_shark.global_position = spawn_position
			print("Respawning shark at: ", spawn_position)
			get_tree().current_scene.add_child(new_shark)
	)

func add_enemy_defeated():
	enemies_defeated += 1
	print("Enemies defeated: %d" % enemies_defeated)

	if enemies_defeated >= TOTAL_ENEMIES:
		trigger_victory()

func trigger_victory():
	print("All 30 zombies defeated! Victory!")
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
	raft_current_health = raft_max_health

	print("Game has been reset!")
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

# --- Raft Health Functions ---
func apply_raft_damage(amount: int):
	raft_current_health = clamp(raft_current_health - amount, 0, raft_max_health)
	emit_signal("raft_health_updated", raft_current_health)
	emit_signal("raft_damage_taken", amount)
	print("Raft damaged by %d. Current health: %d" % [amount, raft_current_health])

	if raft_current_health <= 0:
		sink_raft()

func heal_raft(amount: int):
	raft_current_health = clamp(raft_current_health + amount, 0, raft_max_health)
	emit_signal("raft_health_updated", raft_current_health)
	emit_signal("raft_damage_taken", -amount)
	print("Raft healed by %d. Current health: %d" % [amount, raft_current_health])

func sink_raft():
	print("Raft destroyed! Triggering Game Over scene...")
	get_tree().change_scene_to_file("res://scenes/GameOver.tscn")
