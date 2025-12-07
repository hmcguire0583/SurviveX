extends CharacterBody2D

@export var speed := 20.0
@export var stop_distance := 5.0

var player_chase := false
var player = null
var health = 100
var current_dir := "down"
var math_challenge_active := false
var is_attacking := false
var is_dead := false   # gate AI and animations when dead
#var VanquishLabelScene := preload("res://scenes/vanquish_label.tscn")

func _ready():
	current_dir = "down"
	$AnimatedSprite2D.play("down_idle")
	$ZombieBubble.visible = false
	$DamageLabel.visible = false
	update_health()

	if not $AnimatedSprite2D.animation_finished.is_connected(_on_animation_finished_proxy):
		$AnimatedSprite2D.animation_finished.connect(_on_animation_finished_proxy)

func _physics_process(delta):
	if is_dead or is_attacking:
		return

	# Stop chasing if another zombie is already in a challenge
	if GameManager.challenge_active and not math_challenge_active:
		play_anim(0)
		return

	if player_chase and player and not math_challenge_active:
		var move_vec = player.position - position
		if move_vec.length() > stop_distance:
			var motion = move_vec.normalized() * speed * delta
			var collision = move_and_collide(motion)
			if collision and collision.get_collider().name == "Player":
				show_math_challenge()
			update_direction(move_vec)
			play_anim(1)
		else:
			play_anim(0)
	else:
		play_anim(0)

func _on_detection_area_body_entered(body):
	if is_dead:
		return
	if body.name == "Player" and not math_challenge_active:
		player = body
		player_chase = true

func _on_detection_area_body_exited(body):
	if body == player:
		player = null
		player_chase = false

func update_direction(vec: Vector2):
	if vec == Vector2.ZERO or is_dead:
		return
	if abs(vec.x) > abs(vec.y):
		current_dir = "right" if vec.x > 0 else "left"
	else:
		current_dir = "down" if vec.y > 0 else "up"

func play_anim(movement):
	if is_attacking or is_dead:
		return
	var anim = $AnimatedSprite2D
	match current_dir:
		"right":
			anim.flip_h = false
			anim.play("side_walk" if movement == 1 else "side_idle")
		"left":
			anim.flip_h = true
			anim.play("side_walk" if movement == 1 else "side_idle")
		"down":
			anim.flip_h = false
			anim.play("down_walk" if movement == 1 else "down_idle")
		"up":
			anim.flip_h = false
			anim.play("up_walk" if movement == 1 else "up_idle")
		_:
			anim.flip_h = false
			anim.play("down_idle")

func show_math_challenge():
	if is_dead or GameManager.challenge_active:
		return
	math_challenge_active = true
	GameManager.challenge_active = true   # lock globally
	player_chase = false
	$CollisionShape2D.disabled = true

	if player:
		var vec = player.position - position
		update_direction(vec)
		play_anim(0)

	var bubble = $ZombieBubble
	bubble.visible = true
	if bubble.has_method("start_challenge"):
		bubble.start_challenge()

	if player and player.has_method("start_math_challenge"):
		player.start_math_challenge(position)

	if not bubble.is_connected("correct_answer", Callable(self, "defeat_enemy")):
		bubble.connect("correct_answer", Callable(self, "defeat_enemy"))
	if not bubble.is_connected("wrong_answer", Callable(self, "penalize_player")):
		bubble.connect("wrong_answer", Callable(self, "penalize_player"))

func defeat_enemy():
	if is_dead:
		return

	$CollisionShape2D.disabled = false
	$ZombieBubble.visible = false
	math_challenge_active = false
	GameManager.challenge_active = false   # release lock

	if player and player.has_method("end_math_challenge"):
		player.end_math_challenge()
		# Resume chase after 1 second
		var t = get_tree().create_timer(1.0)
		t.timeout.connect(func():
			if player and not is_dead:
				player_chase = true
		)

	health -= 20
	update_health()
	show_damage_label("-20")

	if health <= 0:
		is_dead = true
		player_chase = false
		velocity = Vector2.ZERO
		$CollisionShape2D.disabled = true

		GameManager.enemies_defeated += 1
		#var label_instance = VanquishLabelScene.instantiate()
		#label_instance.get_node("Label").text = (
			#"You Win!" if GameManager.enemies_defeated >= 3 else "Enemy vanquished!"
		#)
		#get_tree().current_scene.add_child(label_instance)

		$AnimatedSprite2D.play("z_death")
		var t = get_tree().create_timer(1.2)
		t.timeout.connect(func():
			self.queue_free()
		)
	#else:
	#	var ok_label = VanquishLabelScene.instantiate()
	#	ok_label.get_node("Label").text = "Correct Answer! Enemy -20 HP"
	#	get_tree().current_scene.add_child(ok_label)

func penalize_player():
	if is_dead or is_attacking:
		return

	$CollisionShape2D.disabled = false
	$ZombieBubble.visible = false
	math_challenge_active = false
	GameManager.challenge_active = false   # release lock

	if player and player.has_method("end_math_challenge"):
		player.end_math_challenge()
		# Resume chase after 1 second
		var t = get_tree().create_timer(1.0)
		t.timeout.connect(func():
			if player and not is_dead:
				player_chase = true
		)

	if player:
		is_attacking = true
		match current_dir:
			"right":
				$AnimatedSprite2D.flip_h = false
				$AnimatedSprite2D.play("side_attack")
			"left":
				$AnimatedSprite2D.flip_h = true
				$AnimatedSprite2D.play("side_attack")
			"down":
				$AnimatedSprite2D.play("down_attack")
			"up":
				$AnimatedSprite2D.play("up_attack")

		player.health -= 10
		player.update_health()

		# Fallback reset for attack state
		var t2 = get_tree().create_timer(0.6)
		t2.timeout.connect(func(): is_attacking = false)

func _on_animation_finished_proxy(anim_name: String):
	if anim_name.ends_with("_attack"):
		is_attacking = false
		return

	if anim_name == "z_death" and is_dead:
		var frames: SpriteFrames = $AnimatedSprite2D.sprite_frames
		var last_frame = frames.get_frame_count("z_death") - 1
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.frame = last_frame

		var tween = create_tween()
		tween.tween_property($AnimatedSprite2D, "modulate:a", 0.0, 1.0)\
			.set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
		tween.finished.connect(func(): queue_free())

func update_health():
	var healthbar = $HealthBar
	healthbar.value = health
	healthbar.visible = (health > 0 and health < 100)

func show_damage_label(text: String):
	if is_dead:
		return
	var dmg_label = $DamageLabel
	dmg_label.text = text
	dmg_label.visible = true
	dmg_label.modulate = Color(1,1,1,1)
	dmg_label.position = Vector2(0, -20)

	var tween = create_tween()
	tween.tween_property(dmg_label, "position:y", dmg_label.position.y - 30, 0.6)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(dmg_label, "modulate:a", 0.0, 0.6)\
		.set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	tween.finished.connect(func(): dmg_label.visible = false)
