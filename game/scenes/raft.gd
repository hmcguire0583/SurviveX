extends Node2D   # or Control, depending on your raft scene root

var max_health = 100
var health = 100

func apply_damage(amount: int):
	health -= amount
	health = clamp(health, 0, max_health)
	update_health_ui()
	show_damage_label("-" + str(amount))

	if health <= 0:
		sink()

func update_health_ui():
	var bar = get_node_or_null("RaftHealth")
	if bar:
		bar.value = health
		# Only show the bar when raft is damaged (health < max_health and > 0)
		bar.visible = (health > 0 and health < max_health)

func show_damage_label(text: String):
	var label = get_node_or_null("RaftDamage")
	if label:
		label.text = text
		label.visible = true
		label.modulate = Color(1,1,1,1)
		label.position = Vector2(0, -20)

		var tween = create_tween()
		tween.tween_property(label, "position:y", label.position.y - 30, 0.6)\
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_property(label, "modulate:a", 0.0, 0.6)\
			.set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
		tween.finished.connect(func(): label.visible = false)

func sink():
	print("Raft destroyed!")
	# TODO: add game over, respawn, or raft reset logic here
