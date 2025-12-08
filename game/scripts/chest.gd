extends StaticBody2D

var player = null
var chest_opened = false
@export var items: Array[InvItem]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = true
	$chestart.play("closed_chest")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


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
		var woodItem = items.filter(func(i): return i != null and i.name == "wood")
		var scrapItem = items.filter(func(i): return i != null and i.name == "scrap")
		var foodItem = items.filter(func(i): return i != null and i.name == "food")
		for i in range(25):
			player.collect(woodItem[0])
			player.collect(scrapItem[0])
			player.collect(foodItem[0])
		
