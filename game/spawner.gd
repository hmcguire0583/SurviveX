extends Node2D

@onready var enemy = preload("res://enemy.tscn")



func _on_timer_timeout() -> void:
	var ene = enemy.instantiate()
	ene.position = position
	get_parent().get_node("EnemyHandler").add_child(ene)
