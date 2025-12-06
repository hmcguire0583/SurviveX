extends StaticBody2D

@onready var anim = $Sprite2D   # child node

func _ready():
	anim.play("left")   # replace with the actual name of your raft animation
