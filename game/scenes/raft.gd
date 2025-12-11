extends Node2D

@onready var health_bar = $RaftHealth
@onready var damage_label = $RaftDamage

func _ready():
	# Hide UI until raft is damaged
	health_bar.visible = false
	damage_label.visible = false

	# Initialize with GameManager values
	health_bar.max_value = GameManager.raft_max_health
	health_bar.value = GameManager.raft_current_health

	# Connect to GameManager signals
	GameManager.connect("raft_health_updated", Callable(self, "_on_health_updated"))
	GameManager.connect("raft_damage_taken", Callable(self, "_on_damage_taken"))

func _on_health_updated(new_health: int):
	health_bar.value = new_health
	# Show bar only when raft is damaged but not destroyed
	health_bar.visible = (new_health > 0 and new_health < GameManager.raft_max_health)

func _on_damage_taken(amount: int):
	if amount == 0:
		return
	var text = "-%d" % amount if amount > 0 else "+%d" % abs(amount)
	show_damage_label(text)

func show_damage_label(text: String):
	# Only show damage/heal label if raft is between 0 and max health
	var current_health = GameManager.raft_current_health
	if current_health == GameManager.raft_max_health or current_health <= 0:
		return

	damage_label.text = text
	damage_label.visible = true
	damage_label.modulate = Color(1, 1, 1, 1)
	damage_label.position = Vector2(0, -20)
	print("RaftDamage Label showing:", text)

	var tween = create_tween()
	tween.tween_property(damage_label, "position:y", damage_label.position.y - 30, 0.6)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(damage_label, "modulate:a", 0.0, 0.6)\
		.set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	tween.finished.connect(func(): damage_label.visible = false)

func sink():
	print("Raft destroyed! Triggering Game Over scene...")
	get_tree().change_scene_to_file("res://scenes/GameOver.tscn")
