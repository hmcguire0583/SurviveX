extends StaticBody2D

@export var items: Array[InvItem]

func _ready():
	$shopmenu.visible = false
	
func _process(delta):
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player_shop_method"):
		$shopmenu.visible = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("player_shop_method"):
		$shopmenu.visible = false
