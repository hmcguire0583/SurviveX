extends Node2D   # or Control, depending on your raft scene root

var max_health = 100
var health = 100

func _ready():
	# Hide UI until raft is damaged
	$RaftHealth.visible = false
	$RaftDamage.visible = false

func apply_damage(amount: int):
	print("Raft apply_damage called, health before:", health)
	health -= amount
	health = clamp(health, 0, max_health)
	print("Raft health after:", health)

	update_health_ui()
	show_damage_label("-" + str(amount))

	if health <= 0:
		sink()

func update_health_ui():
	$RaftHealth.value = health
	# Only show the bar when raft is damaged (health < max_health and > 0)
	$RaftHealth.visible = (health > 0 and health < max_health)
	print("RaftHealth ProgressBar updated to:", $RaftHealth.value)

func show_damage_label(text: String):
	# Only show damage label if raft has taken damage
	if health == max_health or health <= 0:
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
