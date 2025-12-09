extends StaticBody2D

signal boarded(raft)

var player_in_range = null

func _ready():
	set_process(true)
	$Area2D.connect("body_entered", Callable(self, "_on_body_entered"))
	$Area2D.connect("body_exited", Callable(self, "_on_body_exited"))
	$Sprite2D.play("right")

func _on_body_entered(body):
	print("Entered:", body.name)
	if body.is_in_group("player"):
		player_in_range = body
		print("DEBUG: Boarding triggered!")
		emit_signal("boarded", self)
		# Show the menu instead of starting bubble directly
		$RaftMenu.visible = true
		$RaftMenu.update_unlocks()
		if not $RaftMenu.is_connected("island_selected", Callable(self, "_on_island_selected")):
			$RaftMenu.connect("island_selected", Callable(self, "_on_island_selected"))
func _on_body_exited(body):
	if body == player_in_range:
		player_in_range = null

# Called when a menu button is pressed
func _on_island_selected(island_index: int):
	#debug for math challenge
	#$RaftBubble.start_challenge(dock_name)
	if GameManager.unlocked_islands.has(island_index) and GameManager.unlocked_islands[island_index]:
		GameManager.current_island = island_index
		var player = get_tree().root.get_node("world/Player")
		player.teleport_to_dock(island_index)
	else:
		$RaftBubble.start_challenge(island_index) # Not unlocked yet
		if not $RaftBubble.is_connected("correct_answer", Callable(self, "_on_correct_answer")):
			$RaftBubble.connect("correct_answer", Callable(self, "_on_correct_answer"))
			#print("DEBUG: connecting RaftBubble correct_answer")
		if not $RaftBubble.is_connected("wrong_answer", Callable(self, "_on_wrong_answer")):
			$RaftBubble.connect("wrong_answer", Callable(self, "_on_wrong_answer"))

func _on_correct_answer(island_index: int):
	if !GameManager.unlocked_islands.has(island_index) or GameManager.unlocked_islands[island_index] == false:
		GameManager.unlocked_islands[island_index] = true
		GameManager.islands_unlocked += 1   # simpler counter update
		print("Unlocked dock:", island_index, "| Total unlocked =", GameManager.islands_unlocked)
		
	GameManager.current_island = island_index
	var player = get_tree().root.get_node("world/Player")
	#print("DEBUG: player node =", player)
	player.teleport_to_dock(island_index)

func _on_wrong_answer(island_index: int):
	print("Dock", island_index, "remains locked.")
	var player = get_tree().root.get_node("world/Player")
	var dock4 = get_tree().root.get_node("world/Docks/Dock4")
	player.global_position = dock4.global_position
