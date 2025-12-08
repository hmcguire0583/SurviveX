extends CharacterBody2D

@export var speed: float = 60.0
@export var wander_change_time: float = 2.0   # seconds before picking a new heading

var current_dir: Vector2 = Vector2.RIGHT
var time_accum: float = 0.0

func _ready():
	# Start with a random direction
	current_dir = Vector2.RIGHT.rotated(randf() * TAU)
	velocity = current_dir.normalized() * speed

func _physics_process(delta):
	# Move in current direction
	move_and_slide()

	# Occasionally pick a new random heading
	time_accum += delta
	if time_accum > wander_change_time:
		time_accum = 0.0
		current_dir = Vector2.RIGHT.rotated(randf() * TAU)
		velocity = current_dir.normalized() * speed

	update_direction(velocity)

func update_direction(vec: Vector2):
	var anim = $AnimatedSprite2D
	if abs(vec.x) > abs(vec.y):
		if vec.x > 0:
			anim.flip_h = false
			anim.play("shark_side")
		else:
			anim.flip_h = true
			anim.play("shark_side")
	else:
		if vec.y > 0:
			anim.play("shark_down")
		else:
			anim.play("shark_up")
