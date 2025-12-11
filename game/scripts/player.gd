extends CharacterBody2D

const speed = 120
var current_dir = "none"
var on_boat = false
var boat_ref = null
var health = 100
var is_dead = false
var math_challenge_active = false
var previous_health = 100

var weapon_tier := 1   # 1 = starter sword, 2 = sword2, 3 = sword3
var armor_tier = 0     # 0 = no armor, 1–3 = upgrades
var base_dmg = 20
var is_attacking = false   # track attack state

@export var inv: Inv
@onready var foodItem: InvItem = preload("uid://b8grvgyrabk08")
@onready var repairItem: InvItem = preload("uid://chsnfakysfdkb")
@onready var raft_scene: PackedScene = preload("res://scenes/raft.tscn")
var raft_ref: Node = null

func _ready():
	$AnimatedSprite2D.play("front_idle")
	$AnimatedSprite2D.animation_finished.connect(_on_animation_finished)
	$Damagelabel.visible = false
	
	if get_tree().current_scene.has_node("Raft"):
		raft_ref = get_tree().current_scene.get_node("Raft")
	else:
		raft_ref = raft_scene.instantiate()
		get_tree().current_scene.add_child(raft_ref)
		raft_ref.global_position = Vector2(200, 300)

func _physics_process(delta):
	# Eat food
	if Input.is_action_just_pressed("eat"):
		if not inv.slots.filter(func(slot): return slot.item == foodItem).is_empty():
			remove(foodItem, 1)
			health += 5
			if health > 100:
				health = 100

	# Repair raft
	if Input.is_action_just_pressed("repair"):
		if not inv.slots.filter(func(slot): return slot.item == repairItem).is_empty():
			remove(repairItem, 1)
			GameManager.heal_raft(10)
			print("Repaired raft, new health:", GameManager.raft_current_health)

	if on_boat or is_dead:
		return
	if math_challenge_active:
		velocity = Vector2.ZERO
		return

	# Manual attack input
	if Input.is_action_just_pressed("ui_accept") and not is_attacking:
		queue_attack_animation(current_dir)
		return

	player_movement(delta)
	update_health()

func player_movement(delta):
	if is_dead or is_attacking:
		return

	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_dir = "left"
		play_anim(1)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_down"):
		current_dir = "down"
		play_anim(1)
		velocity.y = speed
		velocity.x = 0
	elif Input.is_action_pressed("ui_up"):
		current_dir = "up"
		play_anim(1)
		velocity.y = -speed
		velocity.x = 0
	else:
		play_anim(0)
		velocity = Vector2.ZERO

	move_and_slide()

func play_anim(movement):
	if is_dead or is_attacking:
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
			anim.play("front_walk" if movement == 1 else "front_idle")
		"up":
			anim.flip_h = false
			anim.play("back_walk" if movement == 1 else "back_idle")

func queue_attack_animation(dir: String):
	if is_dead or is_attacking:
		return

	is_attacking = true
	var anim = $AnimatedSprite2D
	match dir:
		"right":
			anim.flip_h = true
			anim.play("side_attack")
		"left":
			anim.flip_h = false
			anim.play("side_attack")
		"down":
			anim.play("back_attack")
		"up":
			anim.play("front_attack")

	var t = get_tree().create_timer(0.5)
	t.timeout.connect(func():
		if is_attacking:
			is_attacking = false
			play_anim(0)
	)

# --- NEW: damage scaling ---
func get_attack_damage() -> int:
	match weapon_tier:
		1: return base_dmg
		2: return base_dmg + 15
		3: return base_dmg + 25
		_: return base_dmg

# --- NEW: damage reduction based on armor ---
func take_damage(amount: int):
	var reduced = amount
	match armor_tier:
		0: reduced = amount
		1: reduced = int(amount * 0.85)  # 15% reduction
		2: reduced = int(amount * 0.70)  # 30% reduction
		3: reduced = int(amount * 0.50)  # 50% reduction
	health -= reduced
	update_health()

func update_health():
	var healthbar = $HealthBar
	healthbar.value = health
	healthbar.visible = health < 100

	if health < previous_health:
		var damage_amount = previous_health - health
		show_damage_label("-%d" % damage_amount)

	previous_health = health

	if health <= 0 and not is_dead:
		trigger_death()

func trigger_death():
	is_dead = true
	velocity = Vector2.ZERO
	$AnimatedSprite2D.play("death")
	await get_tree().create_timer(0.6).timeout
	get_tree().change_scene_to_file("res://scenes/GameOver.tscn")

func _on_animation_finished(anim_name: String):
	if anim_name.ends_with("_attack"):
		is_attacking = false
		play_anim(0)
	elif is_dead and anim_name == "death":
		var last_frame = $AnimatedSprite2D.sprite_frames.get_frame_count("death") - 1
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.frame = last_frame

func start_math_challenge(zombie_position: Vector2):
	math_challenge_active = true
	velocity = Vector2.ZERO

	var vec = zombie_position - position
	if abs(vec.x) > abs(vec.y):
		current_dir = "right" if vec.x > 0 else "left"
	else:
		current_dir = "down" if vec.y > 0 else "up"

	play_anim(0)

func end_math_challenge():
	math_challenge_active = false

func show_damage_label(text: String):
	var dmg_label = $Damagelabel
	if dmg_label == null:
		push_error("DamageLabel node not found in Player scene!")
		return

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

func player():
	pass

func collect(item, amount):
	inv.insert(item, amount)

func remove(item, amount):
	inv.remove(item, amount)

func getInventory():
	return inv

func player_shop_method():
	pass

func _on_boarded(boat):
	print("Boarded boat:", boat.name)
	on_boat = true
	boat_ref = boat
	global_position = boat.global_position + Vector2(-4, 26)

func teleport_to_dock(island_index: int):
	var docks = get_tree().root.get_node("world/Docks")
	var dock_name = "Dock" + str(island_index)
	print("Looking for dock:", dock_name)
	var dock = docks.get_node_or_null(dock_name)
	if dock:
		global_position = dock.global_position
		print("Teleported to dock:", dock_name)
		on_boat = false
		boat_ref = null
		set_physics_process(true)
	else:
		push_error("Dock not found: " + dock_name)
