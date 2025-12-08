extends StaticBody2D

var player = null
var chest_opened = false
@export var scrapItem: InvItem
@export var woodItem: InvItem
@export var foodItem: InvItem

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = true
	$chestart.play("closed_chest")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
		
		if not chest_opened and GameManager.enemies_defeated >= 1:
			$chestart.play("opening_chest")
			await get_tree().create_timer(0.8).timeout
			$chestart.play("open_chest")
			
			chest_opened = true
			reward_player(player)
			
func reward_player(player):
	if GameManager.enemies_defeated >= 1:
		player.collect(woodItem, 25)
		player.collect(scrapItem, 15)
		player.collect(foodItem, 3)
		pass
		
