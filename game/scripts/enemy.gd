extends CharacterBody2D

@export var speed := 20.0
@export var stop_distance := 5.0
@onready var scrap = $scrap_collectable
@onready var wood = $wood_collectable
@export var scrapItem: InvItem
@export var woodItem: InvItem
var player_chase := false
var player = null
var maxHealth = 100
var health = 20
var current_dir := "down"
var math_challenge_active := false
var is_attacking := false
var is_dead := false   # gate AI and animations when dead
var base_dmg = 15
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
	if body.has_method("player"):
		player = body
		player_chase = true


func _on_detection_area_body_exited(body):
	if body.has_method("player"):
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

	var damage = player.base_dmg + (10 * (player.weapon_tier - 1))
	damage *= 1 - (0.05 * (GameManager.current_day - 1))
	health -= damage
	if GameManager.time == "night":
		damage *= 0.95
	update_health()
	show_damage_label("-" + str(damage))

	if health <= 0:
		is_dead = true
		player_chase = false
		velocity = Vector2.ZERO
		$CollisionShape2D.disabled = true

		GameManager.enemies_defeated += 1
		print(GameManager.enemies_defeated)
		#var label_instance = VanquishLabelScene.instantiate()
		#label_instance.get_node("Label").text = (
			#"You Win!" if GameManager.enemies_defeated >= 3 else "Enemy vanquished!"
		#)
		#get_tree().current_scene.add_child(label_instance)

		$AnimatedSprite2D.play("z_death")
		
		await get_tree().create_timer(1.2).timeout
		drop_scrap()
		#self.queue_free()
		$AnimatedSprite2D.visible = false
		$CollisionShape2D.disabled = true
		$detection_area/CollisionShape2D.disabled = true
		
	#else:
	#	var ok_label = VanquishLabelScene.instantiate()
	#	ok_label.get_node("Label").text = "Correct Answer! Enemy -20 HP"
	#	get_tree().current_scene.add_child(ok_label)
func drop_scrap():
	scrap.visible = true
	wood.visible
	$scrap_collect_area/CollisionShape2D.disabled = false
	scrap_collect()
	
	
func scrap_collect():
	await get_tree().create_timer(0.4).timeout
	scrap.visible = false
	wood.visible = false
	var scrap = 0
	var wood = 0
	randomize()
	if GameManager.current_island <= 1:
		scrap = randi() % 3 + 2
		wood = randi() % 4 + 3
	elif GameManager.current_island == 2:
		scrap = randi() % 4 + 4
		wood = randi() % 5 + 5
	elif GameManager.current_island >= 3:
		scrap = randi() % 5 + 6
		wood = randi() % 6 + 7
	
	print("rewarding ", scrap, " scrap")
	print("rewarding ", wood, " wood")
	player.collect(scrapItem, scrap)
	player.collect(woodItem, wood)
	
	queue_free()

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

		var damage = base_dmg + (10 * (GameManager.current_day) - 1)
		damage += (5 * (GameManager.islands_unlocked - 1))
		damage *= 1 - (0.1 * player.armor_tier)
		if GameManager.time == "night":
			damage *= 1.05
		player.health -= damage
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
	healthbar.visible = (health > 0 and health < maxHealth)

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


func _on_scrap_collect_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
