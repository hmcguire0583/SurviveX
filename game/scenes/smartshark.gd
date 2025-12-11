extends CharacterBody2D

const SPEED = 120.0   # shark swim speed

var target: Node2D = null
var player = null

var math_challenge_active = false
var is_dead = false

var maxHealth = 100
var SharkHealth = 100   # start full

var spawn_position: Vector2   # store where this shark spawned

# Preload the shark scene itself for respawn
@export var shark_scene: PackedScene = preload("res://scenes/smartshark.tscn")

# Preload the vanquish label scene
var VanquishLabelScene = preload("res://scenes/vanquish_label.tscn")

func _ready():
	spawn_position = global_position   # save spawn location
	is_dead = false
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D.play("shark_down")
	$SharkBubble.visible = false
	$detect_raft.body_entered.connect(_on_detect_raft_entered)
	$detect_raft.body_exited.connect(_on_detect_raft_exited)

	# Connect signals once
	if not $SharkBubble.is_connected("correct_answer", Callable(self, "defeat_shark")):
		$SharkBubble.connect("correct_answer", Callable(self, "defeat_shark"))
	if not $SharkBubble.is_connected("wrong_answer", Callable(self, "penalize_player")):
		$SharkBubble.connect("wrong_answer", Callable(self, "penalize_player"))

	# Hide UI until damaged
	$SharkHealth.visible = false
	$SharkDamage.visible = false

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

	# Apply damage to shark
	var damage = 25
	SharkHealth -= damage
	update_health()
	show_damage_label("-" + str(damage))

	if SharkHealth <= 0:
		die()
		return

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

	#  Apply damage to raft immediately
	var raft_nodes = get_tree().get_nodes_in_group("raft")
	if raft_nodes.size() > 0:
		var raft = raft_nodes[0]
		if raft and raft.has_method("apply_damage"):
			raft.apply_damage(50)
			
			
	if is_inside_tree():
		var t = get_tree().create_timer(1.0)
		t.timeout.connect(func():
			if not is_dead:
				show_math_challenge()
				)

func update_health():
	$SharkHealth.max_value = maxHealth
	$SharkHealth.value = SharkHealth
	$SharkHealth.visible = (SharkHealth < maxHealth and SharkHealth > 0)

func show_damage_label(text: String):
	if is_dead:
		return
	$SharkDamage.text = text
	$SharkDamage.visible = true
	$SharkDamage.z_index = 10
	$SharkDamage.modulate = Color(1,1,1,1)
	$SharkDamage.position = Vector2(0, -20)

	var tween = create_tween()
	tween.tween_property($SharkDamage, "position:y", $SharkDamage.position.y - 30, 0.6)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property($SharkDamage, "modulate:a", 0.0, 0.6)\
		.set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	tween.finished.connect(func(): $SharkDamage.visible = false)

func die():
	is_dead = true
	math_challenge_active = false
	velocity = Vector2.ZERO

	$SharkBubble.visible = false
	if has_node("CollisionShape2D"):
		$"CollisionShape2D".disabled = true

	var vlabel_instance = VanquishLabelScene.instantiate()
	if vlabel_instance is Label:
		vlabel_instance.text = "You vanquished the shark, returning to the Island!"
		vlabel_instance.set_anchors_preset(Control.PRESET_CENTER)
	get_tree().current_scene.add_child(vlabel_instance)
	
	var t = get_tree().create_timer(1.0)
	t.timeout.connect(func():
		# THEN teleport player
		if player and player.has_method("teleport_to_dock"):
			player.teleport_to_dock(GameManager.islands_unlocked)
			GameManager.current_island = GameManager.islands_unlocked
		GameManager.queue_shark_respawn(spawn_position)
		queue_free()
	)
func respawn_shark():
	if shark_scene and is_inside_tree():
		var new_shark = shark_scene.instantiate()
		new_shark.global_position = spawn_position
		get_tree().current_scene.add_child(new_shark)
