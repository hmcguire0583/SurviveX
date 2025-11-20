extends CharacterBody2D

@export var speed := 40.0
var player_chase := false
var player = null
var current_dir := "down"  # Default facing direction

func _ready():
	current_dir = "down"
	$AnimatedSprite2D.play("down_idle")

func _physics_process(delta):
	if player_chase and player:
		var move_vec = (player.position - position)
		update_direction(move_vec)
		position += move_vec / speed

		# Only play walk if movement is significant
		if move_vec.length() > 1:
			play_anim(1)
		else:
			play_anim(0)
	else:
		play_anim(0)

func _on_detection_area_body_entered(body):
	player = body
	player_chase = true

func _on_detection_area_body_exited(body):
	if body == player:
		player = null
		player_chase = false

func update_direction(vec: Vector2):
	if vec == Vector2.ZERO:
		return  # Don't update direction if there's no movement
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
			anim.play("down_idle")  # Fallback
