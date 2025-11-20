extends CharacterBody2D

@export var speed := 20.0
var player_chase := false
var player = null
var current_dir := "down"
var math_challenge_active := false
var active_math_screen = null

func _ready():
	current_dir = "down"
	$AnimatedSprite2D.play("down_idle")

func _physics_process(delta):
	if player_chase and player and not math_challenge_active:
		var move_vec = player.position - position
		update_direction(move_vec)

		if move_vec.length() > 1:
			position += move_vec.normalized() * speed * delta
			play_anim(1)
		else:
			play_anim(0)

		if position.distance_to(player.position) < 10:
			show_math_challenge()
	else:
		play_anim(0)

func _on_detection_area_body_entered(body):
	if body.name == "Player":
		player = body
		player_chase = true

func _on_detection_area_body_exited(body):
	if body == player:
		player = null
		player_chase = false

func update_direction(vec: Vector2):
	if vec == Vector2.ZERO:
		return
	if abs(vec.x) > abs(vec.y):
		current_dir = "right" if vec.x > 0 else "left"
	else:
		current_dir = "down" if vec.y > 0 else "up"

func play_anim(movement):
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
	math_challenge_active = true
	player_chase = false

	get_tree().paused = true

	active_math_screen = preload("res://math_screen.tscn").instantiate()
	active_math_screen.set_process_mode(2)
	get_tree().current_scene.add_child(active_math_screen)
	active_math_screen.connect("correct_answer", Callable(self, "defeat_enemy"))

func defeat_enemy():
	get_tree().paused = false

	if active_math_screen:
		active_math_screen.queue_free()

	var label = get_tree().current_scene.get_node("VanquishLabel")
	if label:
		label.text = "Enemy vanquished!"

	queue_free()
