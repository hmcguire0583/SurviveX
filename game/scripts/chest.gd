extends StaticBody2D

var player = null
var chest_opened = false
@export var scrapItem: InvItem
@export var woodItem: InvItem
@export var foodItem: InvItem

var enemiesNeeded = {
	1: 5,
	2: 16,
	3: 29
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = true
	$chestart.play("closed_chest")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
		
		if not chest_opened: 
			var needed = enemiesNeeded[GameManager.enemies_defeated]
			if GameManager.enemies_defeated >= needed:
				$chestart.play("opening_chest")
				await get_tree().create_timer(0.8).timeout
				$chestart.play("open_chest")
				
				chest_opened = true
				reward_player(player)
			
func reward_player(player):
	var scrap = 0
	var wood = 0
	var food = 0
	if GameManager.current_island == 1:
		scrap = randi() % 8 + 8
		wood = randi() % 10 + 12
		food = randi() % 2 + 2
	elif GameManager.current_island == 2:
		scrap = randi() % 11 + 11
		wood = randi() % 13 + 15
		food = randi() % 3 + 3
	elif GameManager.current_island == 1:
		scrap = randi() % 15 + 15
		wood = randi() % 20 + 20
		food = randi() % 4 + 4
		
	player.collect(scrapItem, scrap)
	player.collect(woodItem, wood)
	player.collect(foodItem, food)
		
