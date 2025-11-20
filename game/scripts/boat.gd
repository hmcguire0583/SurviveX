extends CharacterBody2D

@export var tilemap: TileMap

var acceleration := 150.0
var max_speed := 160.0
var turn_speed := 2.5
var water_drag := 0.05
var in_water := false

var player_on_board := false
var player: CharacterBody2D = null

@onready var interact_area: Area2D = $Area2D

func _ready():
	interact_area.body_entered.connect(_on_Area2D_body_entered)
	interact_area.body_exited.connect(_on_Area2D_body_exited)

func _physics_process(delta):
	check_water()
	print("on board:", player_on_board, "in water:", in_water)

	if player_on_board and in_water:
		handle_movement(delta)
		apply_drag(delta)
		# Keep player visually on the boat
		player.global_position = global_position + Vector2(0, 0)
	else:
		velocity = Vector2.ZERO

	# Hop on if near and press E
	if player and Input.is_action_just_pressed("ui_accept"):
		if not player_on_board:
			hop_on()
		else:
			hop_off()

	move_and_slide()

# --------------------
# Water check
# --------------------
func check_water():
	# Convert boat global position relative to the TileMap
	var local_pos = global_position - tilemap.global_position
	var tile_coords = tilemap.local_to_map(local_pos)

	# Get the tile on layer 2 (water)
	var data: TileData = tilemap.get_cell_tile_data(2, tile_coords)
	in_water = data != null and data.get_custom_data("water") == true

	# Debug
	print("Boat global:", global_position, "local:", local_pos, "tile coords:", tile_coords, "in_water:", in_water)



# --------------------
# Boat movement
# --------------------
func handle_movement(delta):
	var input_vector = Vector2.ZERO

	if Input.is_action_pressed("ui_up"):
		input_vector.y -= 1
	if Input.is_action_pressed("ui_down"):
		input_vector.y += 1
	if Input.is_action_pressed("ui_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("ui_right"):
		input_vector.x += 1

	# Normalize for diagonal movement
	if input_vector.length() > 0:
		input_vector = input_vector.normalized()

	# Apply speed
	velocity = input_vector * max_speed

	# Apply drag
	velocity = velocity.move_toward(Vector2.ZERO, water_drag * delta)


func apply_drag(delta):
	velocity = velocity.move_toward(Vector2.ZERO, acceleration * delta)

# --------------------
# Interaction
# --------------------
func _on_Area2D_body_entered(body):
	if body.is_in_group("player") and not player_on_board:
		player = body
		print("Press SPACE to hop on the boat!")

func _on_Area2D_body_exited(body):
	if body == player and not player_on_board:
		player = null

func hop_on():
	if player:
		player_on_board = true
		player.on_boat = true
		player.get_parent().remove_child(player)
		add_child(player)
		player.global_position = global_position + Vector2(0, 0)
		print("Player hopped on!")

func hop_off():
	if player:
		player_on_board = false
		player.on_boat = false
		player.global_position = global_position + Vector2(32, 0)
		print("Player hopped off!")
