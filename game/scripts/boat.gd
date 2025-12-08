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
		$RaftBubble.start_challenge("Dock2")
		$RaftBubble.correct_answer.connect(_on_correct_answer)
		$RaftBubble.wrong_answer.connect(_on_wrong_answer)

func _on_correct_answer(dock_name: String):
	var player = get_tree().root.get_node("world/Player")
	player.teleport_to_dock(dock_name)

func _on_wrong_answer(dock_name: String):
	print("Dock", dock_name, "remains locked.")
