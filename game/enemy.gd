extends AnimatedSprite2D

var speed = 25
var player_chase = false
var player = null
# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	if player_chase:
		position += (player.position - position) / speed

func _on_detection_area_body_entered(body):
	player = body
	player_chase = true
	
func _on_detection_area_body_exited(body):
	player = null
	player_chase = false
