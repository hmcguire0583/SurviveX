extends CharacterBody2D

const speed = 600
var current_dir = "none"
var on_boat = false
var boat_ref = null
var health = 100
var is_dead = false
var math_challenge_active = false
var previous_health = 100   # NEW: track last health value
var weapon_tier := 1
var armor_tier := 0
var base_dmg := 20

@export var inv: Inv
@onready var foodItem: InvItem = preload("uid://b8grvgyrabk08")


func _ready():
	$AnimatedSprite2D.play("front_idle")
	$AnimatedSprite2D.animation_finished.connect(_on_animation_finished)
	$Damagelabel.visible = false   # hide initially
	for boat in get_tree().get_nodes_in_group("raft"):
		print("DEBUG: found boat", boat.name)
		boat.connect("boarded", Callable(self, "_on_boarded"))

func _physics_process(delta):
	if Input.is_action_just_pressed("eat"):
		if not inv.slots.filter(func(slot): return slot.item == foodItem).is_empty():
			remove(foodItem, 1)
			health += 5
			if health > 100:
				health = 100
		
	if on_boat or is_dead:
		return
	if math_challenge_active:
		velocity = Vector2.ZERO
		return
	player_movement(delta)
	update_health()

func player_movement(delta):
	if is_dead:
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
		velocity.x = 0
		velocity.y = 0

	move_and_slide()

func play_anim(movement):
	if is_dead:
		return

	var dir = current_dir
	var anim = $AnimatedSprite2D

	if dir == "right":
		anim.flip_h = false
		anim.play("side_walk" if movement == 1 else "side_idle")
	elif dir == "left":
		anim.flip_h = true
		anim.play("side_walk" if movement == 1 else "side_idle")
	elif dir == "down":
		anim.flip_h = false
		anim.play("front_walk" if movement == 1 else "front_idle")
	elif dir == "up":
		anim.flip_h = false
		anim.play("back_walk" if movement == 1 else "back_idle")

func update_health():
	var healthbar = $HealthBar
	healthbar.value = health
	healthbar.visible = health < 100

	# Show damage popup only when health decreases
	if health < previous_health:
		var damage_amount = previous_health - health
		show_damage_label("-" + str(damage_amount))

	previous_health = health  # update tracker

	if health <= 0 and not is_dead:
		trigger_death()

func trigger_death():
	is_dead = true
	velocity = Vector2.ZERO
	$AnimatedSprite2D.play("death")
	await get_tree().create_timer(0.6).timeout
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_animation_finished(anim_name: String):
	if is_dead and anim_name == "death":
		var last_frame = $AnimatedSprite2D.sprite_frames.get_frame_count("death") - 1
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.frame = last_frame

# Called by zombie when math challenge starts
func start_math_challenge(zombie_position: Vector2):
	math_challenge_active = true
	velocity = Vector2.ZERO

	var vec = zombie_position - position
	if abs(vec.x) > abs(vec.y):
		current_dir = "right" if vec.x > 0 else "left"
	else:
		current_dir = "down" if vec.y > 0 else "up"

	play_anim(0)

# Called by zombie when math challenge ends
func end_math_challenge():
	math_challenge_active = false

# Animate the built-in DamageLabel node
func show_damage_label(text: String):
	var dmg_label = $Damagelabel   # ensure node name matches your scene
	if dmg_label == null:
		push_error("DamageLabel node not found in Player scene!")
		return

	dmg_label.text = text
	dmg_label.visible = true
	dmg_label.modulate = Color(1,1,1,1)  # reset alpha
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
	print("Boarded boat:", boat.name)  # Debug
	on_boat = true
	boat_ref = boat
	# Snap player onto boat deck (adjust offset as needed)
	global_position = boat.global_position + Vector2(-4, 26)
func teleport_to_dock(island_index: int):
	# Find the Docks folder in your World scene
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
