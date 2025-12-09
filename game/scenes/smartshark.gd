extends CharacterBody2D

const SPEED = 120.0   # shark swim speed

var target: Node2D = null
var player = null

var math_challenge_active = false
var is_dead = false

var maxHealth = 100
var SharkHealth = 100   # start full

# Preload the vanquish label scene
var VanquishLabelScene = preload("res://scenes/vanquish_label.tscn")

func _ready():
	$AnimatedSprite2D.play("shark_down")
	$SharkBubble.visible = false
	$detect_raft.body_entered.connect(_on_detect_raft_entered)
	$detect_raft.body_exited.connect(_on_detect_raft_exited)

	# Connect signals once
	if not $SharkBubble.is_connected("correct_answer", Callable(self, "defeat_shark")):
		$SharkBubble.connect("correct_answer", Callable(self, "defeat_shark"))
	if not $SharkBubble.is_connected("wrong_answer", Callable(self, "penalize_player")):
		$SharkBubble.connect("wrong_answer", Callable(self, "penalize_player"))

	update_health()

func _physics_process(delta: float) -> void:
	if is_dead:
		return

	if target and not math_challenge_active:
		var dir = (target.global_position - global_position).normalized()
		velocity = dir * SPEED
		move_and_slide()
		play_direction_anim(dir)
	else:
		velocity = Vector2.ZERO
		move_and_slide()

func _on_detect_raft_entered(body: Node):
	if is_dead:
		return
	if body.is_in_group("player"):
		target = body
		player = body

		# Wait 2 seconds before showing bubble
		var t = get_tree().create_timer(2.0)
		t.timeout.connect(func():
			show_math_challenge()
		)

func _on_detect_raft_exited(body: Node):
	if body == target:
		target = null

func play_direction_anim(dir: Vector2):
	var anim = $AnimatedSprite2D
	if abs(dir.x) > abs(dir.y):
		anim.play("shark_side")
		anim.flip_h = dir.x > 0
	elif dir.y < 0:
		anim.play("shark_up")
	else:
		anim.play("shark_down")

func show_math_challenge():
	if is_dead or math_challenge_active:
		return
	math_challenge_active = true
	$SharkBubble.visible = true
	if $SharkBubble.has_method("start_challenge"):
		$SharkBubble.start_challenge()

func defeat_shark():
	if is_dead:
		return
	$SharkBubble.visible = false
	math_challenge_active = false

	if player and player.has_method("end_math_challenge"):
		player.end_math_challenge()

	# Apply fixed damage
	SharkHealth -= 25
	update_health()
	show_damage_label("-25")

	if SharkHealth <= 0:
		die()
		return

	# Queue up another question after short delay
	var t = get_tree().create_timer(1.0)
	t.timeout.connect(func():
		if not is_dead:
			show_math_challenge()
	)

func penalize_player():
	if is_dead:
		return
	$SharkBubble.visible = false
	math_challenge_active = false

	if player and player.has_method("end_math_challenge"):
		player.end_math_challenge()

	# --- NEW: Damage raft by 20 ---
	var raft = get_tree().current_scene.get_node_or_null("Raft")
	if raft and raft.has_method("apply_damage"):
		raft.apply_damage(20)

	# Queue up another question after short delay
	var t = get_tree().create_timer(1.0)
	t.timeout.connect(func():
		if not is_dead:
			show_math_challenge()
	)

func update_health():
	var healthbar = $SharkHealth
	healthbar.max_value = maxHealth
	healthbar.value = SharkHealth
	healthbar.visible = (SharkHealth > 0 and SharkHealth < maxHealth)

func show_damage_label(text: String):
	if is_dead:
		return
	var dmg_label = $SharkDamage
	dmg_label.text = text
	dmg_label.visible = true
	dmg_label.z_index = 10
	dmg_label.modulate = Color(1,1,1,1)
	dmg_label.position = Vector2(0, -20)

	var tween = create_tween()
	tween.tween_property(dmg_label, "position:y", dmg_label.position.y - 30, 0.6)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(dmg_label, "modulate:a", 0.0, 0.6)\
		.set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	tween.finished.connect(func(): dmg_label.visible = false)

func die():
	is_dead = true
	math_challenge_active = false
	velocity = Vector2.ZERO

	# Hide bubble and disable collisions if present
	$SharkBubble.visible = false
	if has_node("CollisionShape2D"):
		$"CollisionShape2D".disabled = true

	# Instance and show vanquish label (centered)
	var vlabel_instance = VanquishLabelScene.instantiate()
	if vlabel_instance is Label:
		vlabel_instance.text = "You vanquished the shark, go back to the Island!"
		vlabel_instance.set_anchors_preset(Control.PRESET_CENTER)
	get_tree().current_scene.add_child(vlabel_instance)

	# Remove the shark immediately (no death animation)
	queue_free()
