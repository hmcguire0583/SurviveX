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

func _on_body_exited(body):
	if body == player_in_range:
		player_in_range = null

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		print("Boarding triggered!")
		emit_signal("boarded", self)
		# Show the menu instead of starting bubble directly
		$RaftMenu.visible = true
		$RaftMenu.update_unlocks()
		
		if not $RaftMenu.is_connected("island_selected", Callable(self, "_on_island_selected")):
			$RaftMenu.connect("island_selected", Callable(self, "_on_island_selected"))

# Called when a menu button is pressed
func _on_island_selected(dock_name: String):
	#debug for math challenge
	$RaftBubble.start_challenge(dock_name)
	if GameManager.unlocked_islands.has(dock_name):
		var player = get_tree().root.get_node("world/Player")
		player.teleport_to_dock(dock_name)
	else:
		$RaftBubble.start_challenge(dock_name) # Not unlocked yet
		if not $RaftBubble.is_connected("correct_answer", Callable(self, "_on_correct_answer")):
			$RaftBubble.connect("correct_answer", Callable(self, "_on_correct_answer"))
		if not $RaftBubble.is_connected("wrong_answer", Callable(self, "_on_wrong_answer")):
			$RaftBubble.connect("wrong_answer", Callable(self, "_on_wrong_answer"))

func _on_correct_answer(dock_name: String):
	GameManager.unlocked_islands[dock_name] = true
	var player = get_tree().root.get_node("world/Player")
	player.teleport_to_dock(dock_name)

func _on_wrong_answer(dock_name: String):
	print("Dock", dock_name, "remains locked.")
