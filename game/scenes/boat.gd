extends CharacterBody2D

@export var tilemap: TileMap
@export var max_speed := 160
@export var water_drag := 0.1

var in_water := false
var player_on_board := false
var player: CharacterBody2D = null

@onready var interact_area: Area2D = $Area2D


func _ready():
	interact_area.body_entered.connect(_on_Area2D_body_entered)
	interact_area.body_exited.connect(_on_Area2D_body_exited)


func _physics_process(delta):
	check_water()

	# Hop on/off
	if player and Input.is_action_just_pressed("ui_accept"):
		if not player_on_board:
			hop_on()
		else:
			hop_off()

	# Boat movement only when player is onboard AND water
	if player_on_board and in_water:
		handle_movement(delta)
	else:
		velocity = Vector2.ZERO

	move_and_slide()

	# Keep player centered on boat (local coordinates)
	if player_on_board and player:
		player.position = Vector2.ZERO


# -------------------- Water check --------------------
func check_water():
	var local_pos = global_position - tilemap.global_position
	var tile_coords = tilemap.local_to_map(local_pos)
	var data: TileData = tilemap.get_cell_tile_data(2, tile_coords)
	in_water = data != null and data.get_custom_data("water") == true


# -------------------- Boat movement --------------------
func handle_movement(delta):
	var input_vector = Vector2.ZERO
	if Input.is_action_pressed("ui_up"): input_vector.y -= 1
	if Input.is_action_pressed("ui_down"): input_vector.y += 1
	if Input.is_action_pressed("ui_left"): input_vector.x -= 1
	if Input.is_action_pressed("ui_right"): input_vector.x += 1

	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()

	velocity = input_vector * max_speed
	velocity = velocity.move_toward(Vector2.ZERO, water_drag * delta)


# -------------------- Interaction --------------------
func _on_Area2D_body_entered(body):
	if body.is_in_group("player") and not player_on_board:
		player = body
		print("Press E to hop on the boat!")


func _on_Area2D_body_exited(body):
	# DO NOT clear reference while riding
	if player_on_board:
		return

	if body == player:
		player = null


# -------------------- Hop On --------------------
func hop_on():
	if not player:
		return

	player_on_board = true
	player.on_boat = true

	# Reparent safely
	var parent = player.get_parent()
	parent.remove_child(player)
	add_child(player)

	await get_tree().process_frame

	# Place player on top of boat (local space)
	if player:
		player.position = Vector2(0, -10)

	print("Player hopped on!")


# -------------------- Hop Off --------------------
func hop_off():
	if not player:
		return

	player_on_board = false
	player.on_boat = false

	# Reparent back to world
	remove_child(player)
	get_parent().add_child(player)

	await get_tree().process_frame

	# Place beside boat (global space)
	if player:
		player.global_position = global_position + Vector2(16, 0)

	print("Player hopped off!")
