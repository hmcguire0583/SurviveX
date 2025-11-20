extends CharacterBody2D

@export var speed := 20.0
var player_chase := false
var player = null
var current_dir := "side"  # Default facing direction

func _ready():
	current_dir = "side"
	$AnimatedSprite2D.play("shark_side")

func play_anim(movement):
	var anim = $AnimatedSprite2D

	match current_dir:
		"right":
			anim.flip_h = false
			anim.play("shark_side")
		"left":
			anim.flip_h = true
			anim.play("shark_side")
		"down":
			anim.flip_h = false
			anim.play("shark_down")
		"up":
			anim.flip_h = false
			anim.play("shark_up")
		_:
			anim.flip_h = false
			anim.play("shark_down")  # Fallback
