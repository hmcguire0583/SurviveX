extends Node2D   # or Control, depending on your raft scene root

var max_health = 100
var raft_health = 100

func _ready():
	# Hide UI until raft is damaged
	$RaftHealth.visible = false
	$RaftDamage.visible = false

func apply_damage(amount: int):
	raft_health -= amount
	raft_health = clamp(raft_health, 0, max_health)
	update_health_ui()
	if amount > 0:
		show_damage_label("-" + str(amount))
	elif amount < 0:
		show_damage_label("+" + str(abs(amount)))

	if raft_health <= 0:
		sink()

func update_health_ui():
	var bar = get_node_or_null("RaftHealth")
	if bar:
		bar.value = raft_health
		# Only show the bar when raft is damaged (raft_health < max_health and > 0)
		bar.visible = (raft_health > 0 and raft_health < max_health)

func show_damage_label(text: String):
	# Only show damage/heal label if raft is between 0 and max health
	if raft_health == max_health or raft_health <= 0:
		return

	$RaftDamage.text = text
	$RaftDamage.visible = true
	$RaftDamage.modulate = Color(1, 1, 1, 1)
	$RaftDamage.position = Vector2(0, -20)
	print("RaftDamage Label showing:", text)

	var tween = create_tween()
	tween.tween_property($RaftDamage, "position:y", $RaftDamage.position.y - 30, 0.6)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property($RaftDamage, "modulate:a", 0.0, 0.6)\
		.set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	tween.finished.connect(func(): $RaftDamage.visible = false)

func sink():
	print("Raft destroyed! Triggering Game Over scene...")
	get_tree().change_scene_to_file("res://scenes/GameOver.tscn")
